class OsResolver < BaseResolver
  class << self
    def resolve(search = [])
      # binding.pry
      output, _status = Open3.capture2('uname -a')
      version = output.match(/\d{1,2}\.\d{1,2}\.\d{1,2}/).to_s
      # binding.pry
      result = {
        name: output.split(' ')[0],
        family: output.split(' ')[0],
        release: {
          major: version.split('.').first,
          minor: version.split('.')[1],
          full: version
        }
      }

      result = result.dig(*search.map(&:to_sym)) unless search.empty?
      result
    end
  end
end
