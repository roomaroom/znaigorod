module Reviews
  module Content
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text
      end

      def poster
        return URI.parse(poster_url) if poster_url
      end

      def images
        @images ||= begin
                      Images.new(text).images
                    end
      end

      def videos
        @videos ||= begin
                      Videos.new(text).videos
                    end
      end

      def image_for_poster
        @image_for_poster ||= begin
                                Images.new(text).image_for_poster
                              end
      end

      private

      def poster_url
        return image_for_poster.url if image_for_poster

        return videos.first.preview if videos.any?
      end
    end
  end
end
