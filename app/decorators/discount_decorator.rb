# encoding: utf-8

class DiscountDecorator < ApplicationDecorator
  decorates :discount

  def countdown_time
    I18n.l(ends_at, :format => '%Y, %m, %d, %H')
  end

  def when_with_price
    h.content_tag :p, h.content_tag(:span, human_when, :class => :when)
  end

  def human_when
    if price.nil?
      return "Действует: #{I18n.l(starts_at, :format => '%e.%m')} - #{I18n.l(ends_at, :format => '%e.%m.%Y')}".squish
    elsif free?
      return "Действует: #{I18n.l(starts_at, :format => '%e.%m')} - #{I18n.l(ends_at, :format => '%e.%m.%Y')}, бесплатно".squish
    else
      return "Действует: #{I18n.l(starts_at, :format => '%e.%m')} - #{I18n.l(ends_at, :format => '%e.%m.%Y')}, #{h.number_to_currency(price, :unit => 'р.', :precision => 0)}".squish
    end
  end

  def free?
    return true if price.nil? || price.zero?
  end

  def paid?
    return true if price? && price > 0
  end

  def place
    PlaceDecorator.new(:organization => organization) if geo_present?
  end

  def html_description
    @html_description ||= description.to_s.as_html
  end

  def geo_present?
    organization_id? && !organization.latitude.blank? && !organization.longitude.blank?
  end

  def similar_discount
    count = geo_present? ? 3 : 5
    HasSearcher.searcher(:similar_discount).more_like_this(discount).limit(count).results.map { |d| DiscountDecorator.new d }
  end
end
