require 'singleton'

class FactCollection
  include Singleton
  attr_accessor :facts

  def initialize
    @facts = []
  end

  def get(names = [])
    facts.select{|f| names.include?(f.name)}
  end

  def << (fact)
    self.facts << fact
  end
end
