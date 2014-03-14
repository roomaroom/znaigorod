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

      def src
        "//www.youtube.com/embed/#{uid}?autoplay=1&wmode=opaque"
      end
    end
  end
end

