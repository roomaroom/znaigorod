module Reviews
  module Content
    class YoutubeVideo
      attr_accessor :url, :uid

      def initialize(url, uid)
        @url, @uid = url, uid
      end

      def preview
        "http://img.youtube.com/vi/#{uid}/hqdefault.jpg"
      end
    end
  end
end

