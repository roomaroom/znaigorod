class Widgets::WebcamsController < Widgets::ApplicationController
  def yandex
    @webcam = Webcam.our.published.shuffle.first
  end
end
