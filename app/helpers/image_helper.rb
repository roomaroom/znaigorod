# encoding: utf-8

module ImageHelper
  def resized_image_url(url, width, height, options = {})
    return if url.blank?

    return url unless url.match /(\d+\/region\/\d+)|(\/files\/\d+\/\d+-\d+\/)/

    options = { :crop => '!', :magnify => 'm', :orientation => 'n'}.merge(options)

    if url.match(/\d+\/region\/\d+/)
      modified_url = url.gsub(/(\/files\/\d+\/region\/(\d+|\/){8})/) { "#{$1}#{width}-#{height}#{options[:crop]}/" }
    end

    if url.match(/\/files\/\d+\/\d+-\d+\//)
      image_url, image_id, image_width, image_height, image_crop, image_filename = url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]

      modified_url = "#{image_url}/files/#{image_id}/#{width}-#{height}#{options[:crop]}#{options[:magnify]}#{options[:orientation]}/#{image_filename}"
    end

    watermark = options[:watermark].nil? ? true : options[:watermark]

    modified_url.gsub! 'files', 'w/files' if watermark

    modified_url
  end

  def image_direct_url(path)
    URI.join(root_url, image_path(path))
  end

  def vk_image_tag(image, width = 234, height = 158)
    scale = image.width.to_f / image.height.to_f
    new_width  = width
    new_height = width / scale

    delta = new_height - height

    if delta < 0
      new_width += delta.abs
      new_height += delta.abs
    end

    margin_top  = (height/2.0 - new_height/2.0).to_i
    margin_left = (width/2.0  - new_width/2.0).to_i

    image_tag image.file_url,
              :width  => new_width,
              :height => new_height,
              :alt    => image.description,
              :title  => image.description,
              :style  => "position: absolute; left: 0; top: #{margin_top}px; left: #{margin_left}px; display: block;"
  end
end
