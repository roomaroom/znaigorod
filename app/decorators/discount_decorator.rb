# encoding: utf-8

class DiscountDecorator < ApplicationDecorator
  decorates :discount

  def goes_now?
    starts_at < Time.zone.now && ends_at > Time.zone.now
  end

  def will_goes?
    starts_at > Time.zone.now
  end

  def countdown_time
    if goes_now?
      ends_at.to_i * 1000
    else
      starts_at.to_i * 1000
    end
  end

  def when_with_price
    h.content_tag :p, h.content_tag(:span, human_when, :class => :when)
  end

  def human_when
    unless actual?
      return "Было: #{I18n.l(ends_at, :format => '%e.%m.%Y')}".squish
    else
      if constant?
        return 'Постоянная скидка'
      else
        if price.nil?
          return "Действует: #{I18n.l(starts_at, :format => '%e.%m')} - #{I18n.l(ends_at, :format => '%e.%m.%Y')}".squish
        elsif price.zero?
          return "Действует: #{I18n.l(starts_at, :format => '%e.%m')} - #{I18n.l(ends_at, :format => '%e.%m.%Y')}, бесплатно".squish
        else
          return "Действует: #{I18n.l(starts_at, :format => '%e.%m')} - #{I18n.l(ends_at, :format => '%e.%m.%Y')}, #{h.number_to_currency(price, :unit => 'р.', :precision => 0)}".squish
        end
      end
    end
  end

  def free?
    return true if price.nil?
  end

  def human_place
    if geo_present?
      PlaceDecorator.new(:organization => organization).place
    else
      place
    end
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

  def meta_keywords
    kind.map(&:text).map(&:mb_chars).map(&:downcase).join(', ')
  end

  def meta_description
    description.to_s.truncate(200, separator: ' ')
  end
end
