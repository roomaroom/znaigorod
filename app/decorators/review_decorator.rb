# encoding: utf-8

class ReviewDecorator < ApplicationDecorator
  decorates :review

  delegate :title, :to => :review

  def truncated_title(length, separator = ' ')
    title.length > length ?
      title.text_gilensize.truncated(length, separator) :
      title.text_gilensize
  end

  def truncated_title_link(length, options = { separator: ' ', anchor: nil })
    title.length > length ?
      h.link_to(truncated_title(length, options[:separator]), h.review_path(review, anchor: options[:anchor]), :title => title) :
      h.link_to(title.text_gilensize, h.review_path(review, anchor: options[:anchor]))
  end

  def annotation_image(width, height)
    if review.poster_url?
      review.poster_url
    elsif review.poster_image_url?
      h.resized_image_url(review.poster_image_url, width, height)
    else
      'public/post_poster_stub.jpg'
    end
  end

  def date
    date = review.created_at || Time.zone.now

    h.content_tag :div, I18n.l(date, :format => "%d %B %Y"), :class => :date
  end

  def content_for_show
    @content_for_show ||= review.is_a?(ReviewVideo) ?
      AutoHtmlRenderer.new(video_url).render_show + AutoHtmlRenderer.new(content).render_show :
      AutoHtmlRenderer.new(content).render_show
  end

  def content_for_index
    @content_for_index ||= review.is_a?(ReviewVideo) ?
      AutoHtmlRenderer.new(video_url).render_index + AutoHtmlRenderer.new(content).render_index :
      AutoHtmlRenderer.new(content).render_index
  end

  def html_image(image, width, height)
    return "<li>#{h.image_tag h.resized_image_url(image.file_url, width, height), :size => '#{width}x#{height}', :alt => review.title, :title => review.title}</li>"
  end

  def annotation_gallery
    gallery = ''

    review.gallery_images.limit(6).each_with_index do |image, index|
      index == 0 ? gallery << html_image(image, 234, 158) : gallery << html_image(image, 116, 78)
    end

    gallery.html_safe
  end
end
