# encoding: utf-8

class RoomDecorator < ApplicationDecorator
  decorates :room

  def title
    room.title? ? room.title : "Основной номер"
    if room.title?
      room.title
    else
      case room.context.category
      when 'Гостиницы'
        'Основной номер'
      when 'Хостелы'
        'Основной номер'
      when 'Квартиры'
        'Квартира'
      when 'Базы отдыха'
        'Основной номер'
      when 'Загородные дома'
        'Загородный дом'
      end
    end
  end

  def htmlise_features_on_show
    features.map {|f| h.content_tag(:li, f)}.join("\n").html_safe if features.any?
  end

  def different_prices?
    different_prices.many?
  end

  def different_prices
    room.prices.map {|p| [p.value, p.max_value]}.uniq
  end

  def min_price
    room.prices.map { |p| p.value }.min
  end

  def max_price
    different_prices.last.compact.max || 0
  end

  def average_price
    css_class = 'price_value'
    css_class << ' js-ul-toggler ul-toggler' if different_prices?

    h.content_tag :span, humanize_price(min_price, max_price), :class => css_class
  end

  def price_table
    content = ""
    room.prices.each do |price|
      timely_content = " <span>#{price.price_value} руб.</span>; ".html_safe
      content << h.content_tag(:li, ("#{price.day_kind_text}: " + timely_content.squish.gsub(/;$/, '')).html_safe)
    end
    h.content_tag(:ul, content.html_safe, class: 'js-ul-toggleable ul-toggleable').html_safe
  end

  def human_rooms_count
    I18n.t('rooms.count', :count => room.rooms_count)
  end

  def dafault_capacity_value
    "спальных мест: #{room.capacity}"
  end

  def human_capacity
    I18n.t!("rooms.capacity.#{room.capacity}") rescue default_capacity_value
  end

  def has_photogallery?
    images.any?
  end

  def images
    gallery_images
  end
end
