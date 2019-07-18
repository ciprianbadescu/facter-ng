require 'thor'
require 'pry-byebug'

module Facter
  class CLIBase < Thor
    # Without this, Thor will exit 0 when invalid arguments are passed
    # to a command or when the invoked command does not exist.
  end
end
