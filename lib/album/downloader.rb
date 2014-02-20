module Album::Downloader
  extend ActiveSupport::Concern

  included do
    attr_accessor :album_url
  end

  def download_album(url)
    @album_url = url

    create_gallery_images_from_album
  end

  private

  def vk_album?
    album_url.match('vk.com')
  end

  def album_image_urls
    vk_album? ?
      Album::Vkontakte.new(album_url).image_biggest_urls :
      Album::Yandex.new(album_url).image_biggest_urls
  end

  def create_gallery_images_from_album
    album_image_urls.each do |url|
      gallery_images.create! :file => URI.parse(url)
    end
  end
end
