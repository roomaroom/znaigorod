class Prikupon::UnknownCategoryError < StandardError
  attr_accessor :category

  def initialize(category)
    @category = category
  end

  def message
    "#{self.class.name}: unknown category #{category}"
  end
end
