class Reviews::Content::Images
  attr_accessor :text

  def initialize(text)
    @text = text
  end

  def images
    @images ||= begin
                  img_tag_regex         = /<img.*src="(.+?)"/
                  textile_storage_regex = /!(#{Settings['storage.url']}.+?)!/

                  text.scan(/#{img_tag_regex}|#{textile_storage_regex}/).flatten.compact.map { |url| Image.new url }
                end
  end

  def image_for_poster
    @image_for_poster ||= begin
                            images.each do |image|
                              next unless image.dimensions

                              width, height = image.dimensions.width, image.dimensions.height

                              return @image_for_poster = image if width >= Review.min_width && height >= Review.min_height
                            end

                            nil
                          end
  end
end
