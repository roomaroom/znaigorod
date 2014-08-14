class PhotogalleriesController < ApplicationController

  def index
    @photogalleries = Photogallery.order('id desc')
    @photo_decorator = PhotogalleryDecorator.decorate(@photogalleries)
  end

  def show
    @photogallery = Photogallery.find(params[:id])
    #@works = @photogallery.works.ordered.page(params[:page]).per(12)
    @works = if params[:order_by] == 'newest' || params[:order_by].nil?
               @photogallery.works.ordered.page(params[:page]).per(12)
             else
               @photogallery.works.ordered_by_rating.page(params[:page]).per(12)
             end

    @photo_decorator = PhotogalleryDecorator.decorate(@photogallery)

    @photogallery.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
    render :partial => 'works/photogallery_list' and return if request.xhr?
  end
end
