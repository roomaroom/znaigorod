class Widgets::WebcamsController < Widgets::ApplicationController
  def yandex
    @webcam = Webcam.our.published.shuffle.first
    render :layout => false
  end

  def new
    @widget = Widgets::Webcam.new(params[:widget])
  end

  def show
    @widget = Widgets::Webcam.new(:webcam_id => params[:id], :width => params[:width])
    render :partial => 'widgets/webcams/webcam', :layout => false
  end
end
