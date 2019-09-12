# frozen_string_literal: true

class SELinuxResolver < BaseResolver
  # :name
  # :version
  # :codename

  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}

    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]
<<<<<<< HEAD
        result || read_lsb_release_file(fact_name)
      end
    end

    def read_lsb_release_file(fact_name)
      output, _s = Open3.capture2('cat /proc/self/mounts')
      @@fact_list[:enabled] = false

      output.each_line do |line|
        next unless line.match(/selinuxfs/)

        @@fact_list[:enabled] = true
        @@fact_list[:mountpoint] = line
        break
      end

      @@fact_list[fact_name]
=======

        return result unless result.nil?

        output, _s = Open3.capture2('cat /proc/self/mounts')
        @@fact_list[:enabled] = false

        output.each_line do |line|
          next unless line.match?(/selinuxfs/)

          @@fact_list[:enabled] = true
          @@fact_list[:mountpoint] = line
          break
        end

        @@fact_list[fact_name]
      end
>>>>>>> (FACT-2010) Added Os fact for Fedora
    end

    def invalidate_cache
      @@fact_list = {}
    end
  end
end
