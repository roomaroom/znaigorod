class Widgets::Webcam
  include ActiveAttr::MassAssignment

  attr_accessor :webcam_slug, :width, :styles, :height

  def initialize(params = {})
    super(params)
    self.width ||= 260
    self.height = self.width*370/640
  end

  def webcam
    @webcam ||= Webcam.find_by_slug(webcam_slug) || Webcam.our.published.shuffle.first
  end
end
