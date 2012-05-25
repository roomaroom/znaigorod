# encoding: utf-8

module ApplicationHelper
  def facet_status(facet, row)
    result = params_have_facet?(facet, row.value) ? 'selected' : 'unselected'
    result << ' inactive' if row.count.zero?

    result
  end

  def poster_image_tag_for(affiche, width, height, crop = true)
    return image_tag affiche.poster_url, :width => width, :height => height
    image_tag resized_image_url(affiche.poster_url, width, height, crop)
  end

  def image_image_tag_for(affiche, width, height)
    image_tag resized_image_url(affiche.image_url, width, height, true)
  end

  private
    def resized_image_url(url, width, height, crop)
      image_url, image_id, image_width, image_height, image_crop, image_filename =
          url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]

      image_crop = crop ? '!' : ''

      "#{image_url}/files/#{image_id}/#{width}-#{height}#{image_crop}/#{image_filename}"
    end
end
