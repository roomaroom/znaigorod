# encoding: utf-8

class MealDecorator < SuborganizationDecorator
  decorates :meal

  def characteristics_on_list
    characteristics_by_type("features offers cuisines")
  end

  def characteristics_on_show
    characteristics_by_type("categories features offers cuisines")
  end

end
