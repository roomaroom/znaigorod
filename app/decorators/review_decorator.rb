# encoding: utf-8

class ReviewDecorator < ApplicationDecorator
  decorates :review

  def date
    date = review.created_at || Time.zone.now

    h.content_tag :div, I18n.l(date, :format => "%d %B %Y"), :class => :date
  end

  def content_for_show
    @content_for_index ||= review.is_a?(ReviewVideo) ?
      AutoHtmlRenderer.new(video_url).render_show + AutoHtmlRenderer.new(content).render_show :
      AutoHtmlRenderer.new(content).render_show
  end

  def content_for_index
    @content_for_index ||= review.is_a?(ReviewVideo) ?
      AutoHtmlRenderer.new(video_url).render_index :
      AutoHtmlRenderer.new(content).render_index
  end

  def html_image(image, width, height)
    return "<li>#{h.image_tag h.resized_image_url(image.file_url, width, height), :size => '#{width}x#{height}', :alt => review.title, :title => review.title}</li>"
  end

  def annotation_gallery
    gallery_size = review.gallery_images.limit(6).size

    gallery = ''

    review.gallery_images.limit(6).each do |image|
      case gallery_size
      when 1..3
        gallery << html_image(image, (347 / gallery_size) - 2, 260)
      when 4
        gallery << html_image(image, (347 / 2) - 2, (260 / 2) - 2)
      else
        gallery << html_image(image, (347 / gallery_size), 260 / gallery_size)
      end
    end

    gallery.html_safe
  end
end
