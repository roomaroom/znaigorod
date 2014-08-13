class PhotogalleriesController < ApplicationController

  def index
    @photogalleries = Photogallery.order('id desc')
  end

  def show
    @photogallery = Photogallery.find(params[:id])
    @works = @photogallery.works.ordered.page(params[:page]).per(12)

    render :partial => 'works/list' and return if request.xhr?
  end
end
