class Album::Yandex
  # TODO: optimize me
  class Image
    attr_accessor :hash

    def initialize(hash)
      @hash = hash
    end

    def img
      hash['img']
    end

    def small_sizes
      %w[XXXS XXS XS S]
    end

    def big_sizes
      %w[XXXL XXL XL L]
    end

    def small_url
      small_sizes.each { |size| return img[size]['href'] if img[size] }
    end

    def big_url
      big_sizes.each { |size| return img[size]['href'] if img[size] }
    end

    def medium_url
      img.try(:[], 'M').try(:[], 'href')
    end

    def orig_url
      img.try(:[], 'orig').try(:[], 'href')
    end

    def biggest_url
      orig_url || big_url || medium_url || small_url
    end

    def big_width
      big_sizes.each { |size| return img[size]['width'] if img[size] }
    end

    def big_height
      big_sizes.each { |size| return img[size]['height'] if img[size] }
    end

    def orig_width
      img.try(:[], 'orig').try(:[], 'width')
    end

    def orig_height
      img.try(:[], 'orig').try(:[], 'height')
    end

    def width
      big_width || orig_width
    end

    def height
      big_height || orig_height
    end

    def description
      hash['summary']
    end
  end

  attr_accessor :url

  # Accepts urls like http://fotki.yandex.ru/users/s-s-nega/album/131256
  def initialize(url)
    @url = url
  end

  def images
    images_data.map { |elem| Image.new(elem) }
  end

  def image_biggest_urls
    images.map(&:biggest_url)
  end

  private

  def params
    { :format => 'json' }
  end

  def path
    "#{url.match(/users.+/)}/photos/"
  end

  def api_url
    'http://api-fotki.yandex.ru/api'
  end

  def request_url
    "#{api_url}/#{path}?#{params.to_query}"
  end

  def response
    HTTParty.get(request_url).parsed_response
  end

  def images_data
    @images_data ||= response['entries'] || []
  end
end
