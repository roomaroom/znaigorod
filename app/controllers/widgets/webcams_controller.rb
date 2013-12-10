class Widgets::WebcamsController < Widgets::ApplicationController
  def yandex
    @widget = Widgets::Webcam.new(:width => 260)
    render :partial => 'widgets/webcams/webcam', :layout => false
  end

  def new
    @widget = Widgets::Webcam.new(params[:widget])
  end

  def show
    @widget = Widgets::Webcam.new(:webcam_id => params[:id], :width => params[:width])
    render :partial => 'widgets/webcams/webcam', :layout => false
  end
end
