class Widgets::Webcam
  include ActiveAttr::MassAssignment

  attr_accessor :webcam_id, :width, :styles, :height

  def initialize(params = {})
    super(params)
    self.width = self.width.to_i.zero? ? 260 : self.width.to_i
    self.height = self.width*370/640
  end

  def random?
    webcam_id.blank?
  end

  def webcam
    @webcam ||= ::Webcam.find_by_id(webcam_id) || Webcam.our.published.shuffle.first
  end

  def full_width
    width + 25
  end

  def full_height
    h = height + 40
    h += 20 if random?
    h
  end

  def embded_code
    view = Template.new(Rails.root.join('app', 'views'))
    view.assign(widget: self)
    view.render(partial: 'widgets/webcams/embded_code', :layout => false)
  end

  class Template < ActionView::Base
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::TagHelper

    def default_url_options
      {host: Settings['app.host']}
    end
  end
end
