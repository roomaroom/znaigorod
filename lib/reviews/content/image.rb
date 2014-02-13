class Reviews::Content::Image
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def dimensions
    @dimensions ||= from_storage? ? storage_dimensions : remote_dimensions
  end

  private

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
end
