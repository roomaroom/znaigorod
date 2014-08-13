class PhotogalleryDecorator < ApplicationDecorator
  decorates :photogallery

  include OpenGraphMeta

  def truncated_title_link(width = 40)
    if photogallery.title.length > width
      h.link_to h.truncate(photogallery.title, length: width).text_gilensize, h.photogallery_url(photogallery), title: title
    else
      h.link_to title, h.photogallery_url(photogallery)
    end
  end

  def date
    date = photogallery.created_at || Time.zone.now

    h.content_tag :div, I18n.l(date, :format => "%d %B %Y"), :class => :date
  end

  def likes_count
    votes.liked.size
  end
end
