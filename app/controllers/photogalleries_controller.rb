class PhotogalleriesController < ApplicationController

  def index
    @photogalleries = Photogallery.order('id desc')
    @p = PhotogalleryDecorator.decorate(@photogalleries)
  end

  def show
    @photogallery = Photogallery.find(params[:id])
    @works = @photogallery.works.ordered.page(params[:page]).per(12)

    @p = PhotogalleryDecorator.decorate(@photogallery)

    @p.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
    render :partial => 'works/photogallery_list' and return if request.xhr?
  end
end
