class Posts::ContentParser
  attr_accessor :content

  def initialize(content)
    @content = content
  end

  def poster
    return URI.parse(poster_url) if poster_url
  end

  def poster_url
    return image_for_poster.url if image_for_poster

    return youtube_videos.first.preview if youtube_videos.any?
  end

  def youtube_videos_obj
    @youtube_videos ||= YoutubeVideos.new(content)
  end
  delegate :youtube_videos, :to => :youtube_videos_obj

  def images_obj
    @images_obj ||= Images.new(content)
  end

  def image_for_poster
    @image_for_poster ||= images_obj.image_for_poster
  end
  delegate :images, :to => :images_obj

  class YoutubeVideos
    attr_accessor :content

    def initialize(content)
      @content = content
    end

    def youtube_videos
      @youtube_videos ||= begin
                    regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/

                    content.scan(regex).map do |match_groups|
                      YoutubeVideo.new "http://#{match_groups.join}", match_groups[2]
                    end
                  end
    end
  end

  class YoutubeVideo
    attr_accessor :url, :uid

    def initialize(url, uid)
      @url, @uid = url, uid
    end

    def preview
      "http://img.youtube.com/vi/#{uid}/hqdefault.jpg"
    end
  end

  class Images
    attr_accessor :content

    def initialize(content)
      @content = content
    end

    def images
      @images ||= begin
                    img_tag_regex         = /<img.*src="(.+?)"/
                    textile_storage_regex = /!(#{Settings['storage.url']}.+?)!/

                    content.scan(/#{img_tag_regex}|#{textile_storage_regex}/).flatten.compact.map { |url| Image.new url }
                  end
    end

    def image_for_poster
      @image_for_poster ||= begin
                              min = 300

                              images.each do |image|
                                next unless image.dimensions

                                width, height = image.dimensions.width, image.dimensions.height

                                return @image_for_poster = image if width >= min && height >= min
                              end

                              nil
                            end
    end

    class Image
      attr_accessor :url

      def initialize(url)
        @url = url
      end

      def from_storage?
        @from_storage ||= url.match(/#{Settings['storage.url']}.+?/)
      end

      def storage_dimensions
        StorageImageDimensions.new(url)
      end

      def remote_dimensions
        tempfile = Tempfile.open(SecureRandom.hex)
        tempfile.binmode
        tempfile << open(url).read

        Paperclip::Geometry.from_file(tempfile)
      rescue
        nil
      end

      def dimensions
        @dimensions ||= from_storage? ? storage_dimensions : remote_dimensions
      end
    end
  end
end

