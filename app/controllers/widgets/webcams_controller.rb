class Widgets::WebcamsController < Widgets::ApplicationController
  layout false

  def new
    @widget = Widgets::Webcam.new(params[:widget])

    render :layout => 'public'
  end

  def show
    @widget = Widgets::Webcam.new(:webcam_id => params[:id], :width => params[:width])

    render :partial => 'widgets/webcams/webcam'
  end

  def yandex
    @widget = Widgets::Webcam.new(:width => 260)

    render :partial => 'widgets/webcams/webcam'
  end
end
