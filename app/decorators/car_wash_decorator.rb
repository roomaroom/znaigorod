# encoding: utf-8

class CarWashDecorator < SuborganizationDecorator
  decorates :car_wash

  def title
    car_wash.title? ? car_wash.title : 'Автомойка'
  end

  def htmlise_title_on_show
    h.content_tag :h1, title, :class => 'car_wash'
  end
end
