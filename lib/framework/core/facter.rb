# frozen_string_literal: true

require 'pathname'

ROOT_DIR = Pathname.new(File.expand_path('../..', __dir__)) unless defined?(ROOT_DIR)
require "#{ROOT_DIR}/lib/framework/core/file_loader"

require "#{ROOT_DIR}/lib/framework/formatters/fact_formater"
require "#{ROOT_DIR}/lib/framework/formatters/hocon_fact_formatter"
require "#{ROOT_DIR}/lib/framework/formatters/json_fact_formatter"
require "#{ROOT_DIR}/lib/framework/formatters/yaml_fact_formatter"

require "#{ROOT_DIR}/lib/framework/core/fact_augmenter"

require "#{ROOT_DIR}/lib/framework/parsers/query_parser"

module Facter
  def self.to_hash
    Facter::Base.new.resolve_facts([])
  end

  def self.to_hocon(*args)
    resolved_facts = Facter::Base.new.resolve_facts(args)
    fact_formatter = Facter::FactFormater.new
    fact_formatter.format_facts(resolved_facts, Facter::JsonFactFormatter.new)
  end

  def self.value(*args)
    Facter::Base.new.resolve_facts(args)
  end

  class Base
    def resolve_facts(user_query)
      os = OsDetector.detect_family
      legacy_flag = false
      loaded_facts_hash = if user_query.any? || legacy_flag
                            Facter::FactLoader.load_with_legacy(os)
                          else
                            Facter::FactLoader.load(os)
                          end

      searched_facts = Facter::QueryParser.parse(user_query, loaded_facts_hash)
      resolve_matched_facts(searched_facts)
    end

    private

    def resolve_matched_facts(resolved_facts)
      threads = start_threads(resolved_facts)
      resolved_facts = join_threads(threads, resolved_facts)
      FactFilter.new.filter_facts!(resolved_facts)

      resolved_facts
    end

    def start_threads(searched_facts)
      threads = []

      searched_facts.each do |searched_fact|
        threads << Thread.new do
          create_fact(searched_fact)
        end
      end

      threads
    end

    def create_fact(searched_fact)
      fact_class = searched_fact.fact_class
      if searched_fact.name.end_with?('.*')
        fact_without_wildcard = searched_fact.name[0..-3]
        filter_criteria = searched_fact.user_query.split(fact_without_wildcard).last
        fact_class.new.call_the_resolver(filter_criteria)
      else
        fact_class.new.call_the_resolver
      end
    end

    def join_threads(threads, searched_facts)
      resolved_facts = []

      threads.each do |thread|
        thread.join
        resolved_facts << thread.value
      end

      resolved_facts.flatten!
      fact_augmenter = FactAugmenter.new

      fact_augmenter.augment_resolved_facts(searched_facts, resolved_facts)
    end
  end
end