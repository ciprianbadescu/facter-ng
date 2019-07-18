class Fact
  attr_accessor :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end

  def hash?
    !value.is_a?(String)
  end
end
