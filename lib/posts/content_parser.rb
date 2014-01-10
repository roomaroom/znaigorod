class Posts::ContentParser
  attr_accessor :content

  def initialize(content)
    @content = content
  end

  def poster
    return gallery_images.first if gallery_images.any?

    return first_youtube_video_preview if youtube_videos.any?

    return stub_poster
  end

  def gallery_images
    @gallery_images ||= begin
                          urls = content.scan(/!(#{Settings['storage.url']}.*?)!/).flatten

                          GalleryImage.where :file_url => urls
                        end
  end

  def youtube_videos
    @youtube_videos ||= begin
                          regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/

                          content.scan(regex).map do |match_groups|
                            Hashie::Mash.new :url => match_groups.join, :uid => match_groups[2], :preview => "http://img.youtube.com/vi/#{match_groups[2]}/hqdefault.jpg"
                          end
                        end
  end

  def stub_poster
    @stub_poster ||= begin
                      GalleryImage.create! :file => File.open(Rails.root.join('app/assets/images/public/post_poster_stub.jpg'))
                     end
  end

  def first_youtube_video_preview
    @first_youtube_video_preview ||= GalleryImage.create!(:file => URI.parse(youtube_videos.first.preview))
  end
end
