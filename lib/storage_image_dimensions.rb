class StorageImageDimensions
  attr_accessor :height, :width

  def initialize(url)
    @width, @height = url.match(/files\/\d+\/(\d+)-(\d+)/).to_a[1..-1]
  end

  def dimensions
    [width, height].join('x')
  end
end
