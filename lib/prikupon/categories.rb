# encoding: utf-8

class Prikupon::Categories
  attr_accessor :category

  def initialize(category)
    @category = category
  end

  def kind
    kind = categories[category]

    raise Prikupon::UnknownCategoryError, category unless kind

    kind
  end

  private

  def categories
    {
      'Без категории'       => :other,
      'благотворительность' => :other,
      'для авто'            => :auto,
      'для влюбленных'      => :other,
      'для детей'           => :children,
      'для животных'        => :other,
      'для мам и малышей'   => :children,
      'доставка'            => :other,
      'здоровье'            => :beauty,
      'красота'             => :beauty,
      'обучение'            => :other,
      'одежда/обувь'        => :wear,
      'подарки'             => :other,
      'развлечения'         => :entertainment,
      'разное'              => :other,
      'рестораны/кафе'      => :cafe,
      'события'             => :other,
      'спорт'               => :beauty,
      'товары'              => :other
    }
  end
end
