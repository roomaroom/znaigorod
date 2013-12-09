class Widgets::WebcamsController < Widgets::ApplicationController
  def yandex
    @webcam = Webcam.our.published.shuffle.first
    render :layout => false
  end

  def new
    @widget = Widgets::Webcam.new
  end
end
