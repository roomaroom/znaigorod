# encoding: utf-8

class ReviewDecorator < ApplicationDecorator
  decorates :review

  def date
    date = review.created_at || Time.zone.now

    h.content_tag :div, I18n.l(date, :format => "%d %B %Y"), :class => :date
  end

  def annotation_gallery
    if review.gallery_images
    end
  end
end
