# frozen_string_literal: true

class DebianVersionResolver < BaseResolver
  # :major
  # :minor
  # :full

  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}

    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]
        result || read_debian_version(fact_name)
      end
    end

    def read_debian_version(fact_name)
      output, _status = Open3.capture2('cat /etc/debian_version')
      full_version = output.delete("\n")
      versions = full_version.split('.')

      @@fact_list[:full] = full_version
      @@fact_list[:major] = versions[0]
      @@fact_list[:minor] = versions[1].gsub(/^0([1-9])/, '\1')

      @@fact_list[fact_name]
    end
  end
end
