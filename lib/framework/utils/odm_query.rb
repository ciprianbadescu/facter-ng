# frozen_string_literal: true

# PdDv (Predefined Devices) the list of all devices supported by this release of AIX
# PdAt (Predefined Attributes) default values for all device attributes
# CuDv (Customized Devices) the devices present on this machine
# CuAt (Customized Attributes) non-default attribute values

module Facter
  class ODMQuery
    REPOS = %w[CuDv CuAt PdAt PdDv].freeze

    def initialize
      @query = ''
      @conditions = []
    end

    def equals(field, value)
      @conditions << "'#{field}' = '#{value}'"
      self
    end

    def like(field, value)
      @conditions << "'#{field}' like '#{value}'"
      self
    end

    def execute
      result = ''
      REPOS.each do |repo|
        break unless result

        result, _s = Open3.capture2("#{query} #{repo}")
      end
      result
    end

    def query
      'odmget -q ' + @conditions.join(' AND ')
    end
  end
end
