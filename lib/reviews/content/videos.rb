module Reviews
  module Content
    class Videos
      attr_accessor :text

      def initialize(text)
        @text = text
      end

      def videos
        @videos ||= begin
                      youtube_videos
                    end
      end

      private

      def youtube_videos
        regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/

        text.scan(regex).map do |match_groups|
          YoutubeVideo.new match_groups.join, match_groups[2]
        end
      end
    end
  end
end
