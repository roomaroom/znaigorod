module Reviews
  module Content
    class VimeoVideo
      attr_accessor :url, :uid

      def initialize(url, uid)
        @url, @uid = url, uid
      end

      def preview
        preview_url
      end

      private

      def video_info
        @video_info ||= HTTParty.get("http://vimeo.com/api/v2/video/#{uid}.json").parsed_response
      end

      def preview_url
        video_info.first['thumbnail_large'] || video_info.first['thumbnail_medium']
      end
    end
  end
end

