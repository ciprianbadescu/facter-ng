# frozen_string_literal: true

require 'rbconfig'

class OsDetector
  class << self
    def detect_family
      @detect_family ||= begin
        host_os = RbConfig::CONFIG['host_os']
        case host_os
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
          :windows
        when /darwin|mac os/
          :macosx
        when /linux/
          check_os_release
        when /solaris|bsd/
          :unix
        when /aix/
          :aix
        else
          raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
        end
      end
    end

    def check_os_release
      slug = ''
      [OsReleaseResolver, RedHatReleaseResolver, SuseReleaseResolver].each do |resolver|
        slug = resolver.resolve(:slug)
        puts 'detected linux family: ' + slug.inspect
        break if slug
      end
      slug
    end
  end
end
