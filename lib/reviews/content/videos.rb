module Reviews
  module Content
    class Videos
      attr_accessor :text

      def initialize(text)
        @text = text
      end

      def videos
        @videos ||= begin
                      youtube_videos + vimeo_videos
                    end
      end

      private

      def youtube_videos
        regex = /(https?:\/\/)?(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/

        text.scan(regex).map do |matched_groups|
          YoutubeVideo.new matched_groups.join, matched_groups[3]
        end
      end

      def vimeo_videos
        regex = /https?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/

        text.scan(regex).map do |matched_groups|
          VimeoVideo.new "https://vimeo.com/#{matched_groups[1]}", matched_groups[1]
        end
      end
    end
  end
end
