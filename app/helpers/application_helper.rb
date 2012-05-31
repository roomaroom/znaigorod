# encoding: utf-8

module ApplicationHelper
  def facet_status(facet, row)
    result = params_have_facet?(facet, row.value) ? 'selected' : 'unselected'
    result << ' inactive' if row.count.zero?

    result
  end

  def image_tag_for(url, width, height, crop = true)
    image_tag resized_image_url(url, width, height, crop)
  end

  def image_image_tag_for(affiche, width, height, options={})
    image_tag resized_image_url(affiche.image_url, width, height, true), :alt => affiche.title, :title => affiche.title
  end

  def price_for(showing)
    return 'бесплатно' if showing.price_min.zero? && showing.price_max.zero?
    return number_to_currency(showing.price_min, :precision => 0) if showing.price_max.zero?

    "#{showing.price_min} &mdash; #{number_to_currency(showing.price_max, :precision => 0)}".html_safe
  end

  def path_for(item)
    case item.class.superclass.name
    when 'Affiche'
      affiche_path(item)
    when 'Organization'
      organization_path(item)
    end
  end

  def search_class(resource_class)
    return resource_class if [Affiche, Organization].include?(resource_class)
    return Affiche        if Affiche.descendants.include?(resource_class)
    return Organization   if Organization.descendants.include?(resource_class)
  end

  private
    def resized_image_url(url, width, height, crop)
      image_url, image_id, image_width, image_height, image_crop, image_filename =
          url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]

      image_crop = crop ? '!' : ''

      "#{image_url}/files/#{image_id}/#{width}-#{height}#{image_crop}/#{image_filename}"
    end
end
