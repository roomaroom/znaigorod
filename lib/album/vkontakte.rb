class Album::Vkontakte
  class Image
    attr_accessor :hash

    def initialize(hash)
      @hash = hash
    end

    def big_url
      hash['src_xxbig'] || hash['src_xbig'] || hash['src_big']
    end

    def url
      hash['src']
    end

    def small_url
      hash['src_small']
    end

    def biggest_url
      big_url || url || small_url
    end

    def width
      hash['width']
    end

    def height
      hash['height']
    end

    def description
      hash['text']
    end
  end

  attr_accessor :url

  # Accepts urls like http://vk.com/album-35689602_173541663
  def initialize(url)
    @url = url
  end

  def images
    images_data.map { |elem|
      Image.new(elem['photo'])
    }
  end

  def image_biggest_urls
    images.map(&:biggest_url)
  end

  private

  def uid_or_gid
    url.scan(/\d+/).first
  end

  def aid
    url.scan(/\d+/).last
  end

  def app_id
    Settings['vk.app_id']
  end

  def app_secret
    Settings['vk.app_secret']
  end

  def common_params
    { :aid => aid, :api_id => app_id, :format => 'JSON', :method => 'photos.get' }
  end

  def params_with_uid
    Hash[common_params.merge(:uid => uid_or_gid).sort]
  end

  def params_with_gid
    Hash[common_params.merge(:gid => uid_or_gid).sort]
  end

  def digest(params)
    string = params.map { |param, value| "#{param}=#{value}" }.join
    string << app_secret

    Digest::MD5.hexdigest string
  end

  def query(params)
    "#{params.to_query}&sig=#{digest(params)}"
  end

  def api_url
    'http://api.vk.com/api.php'
  end

  def request_url(params)
    "#{api_url}?#{query(params)}"
  end

  def user_images_response
    HTTParty.get(request_url(params_with_uid))
  end

  def group_images_response
    HTTParty.get(request_url(params_with_gid))
  end

  def images_from(httparty_response)
    httparty_response.parsed_response['response'] || []
  end

  def images_data
    @images_data ||= images_from(user_images_response) + images_from(group_images_response)
  end
end
