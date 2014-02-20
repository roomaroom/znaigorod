class Album::Yandex
  class Image
    attr_accessor :hash

    def initialize(hash)
      @hash = hash
    end

    def img
      hash['img']
    end

    def small_url
      img.try(:[], 'XXXS').try(:[], 'href') || img.try(:[], 'XXS').try(:[], 'href') || img.try(:[], 'XS').try(:[], 'href') || img.try(:[], 'S').try(:[], 'href')
    end

    def medium_url
      img.try(:[], 'M').try(:[], 'href')
    end

    def big_url
      img.try(:[], 'XXXL').try(:[], 'href') || img.try(:[], 'XXL').try(:[], 'href') || img.try(:[], 'XL').try(:[], 'href') || img.try(:[], 'L').try(:[], 'href')
    end

    def orig_url
      img.try(:[], 'orig').try(:[], 'href')
    end

    def biggest_url
      orig_url || big_url || medium_url || small_url
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
