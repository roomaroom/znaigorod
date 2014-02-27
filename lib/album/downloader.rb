module Album::Downloader
  extend ActiveSupport::Concern

  included do
    attr_accessor :album_url
  end

  def download_album(url)
    @album_url = url

    create_gallery_social_images_from_album
  end

  private

  def vk_album?
    album_url.match('vk.com')
  end

  def album_images
    vk_album? ?
      Album::Vkontakte.new(album_url).images :
      Album::Yandex.new(album_url).images
  end

  def find_or_initialize_gallery_social_image_by(file_url, thumbnail_url)
    gallery_social_images.find_or_initialize_by_file_url_and_thumbnail_url(
      :file_url => file_url,
      :thumbnail_url => thumbnail_url
    )
  end

  def find_or_initialize_gallery_social_image_for(image)
    vk_album? ?
      find_or_initialize_gallery_social_image_by(image.big_url, image.url) :
      find_or_initialize_gallery_social_image_by(image.big_url || image.orig_url, image.medium_url)
  end

  def create_gallery_social_images_from_album
    album_images.each do |image|
      next if image.width.nil? || image.height.nil?

      img = find_or_initialize_gallery_social_image_for(image)

      img.width = image.width
      img.height = image.height
      img.description = image.description || ''

      img.save :validate => false
    end
  end
end
