class WidgetBannersController < ApplicationController
  def index
    @widget = Widgets::Webcam.new(params[:widget])
  end
end
