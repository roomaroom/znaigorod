class Prikupon::UnknownTypeError < StandardError
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def message
    "#{self.class.name}: unknown type #{type}"
  end
end
