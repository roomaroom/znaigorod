class PhotogalleriesController < ApplicationController
  helper_method :page, :per_page, :current_count, :total_count

  def index
    @photogalleries = Photogallery.order('id desc')
    @photo_decorator = PhotogalleryDecorator.decorate(@photogalleries)
  end

  def show
    @photogallery = Photogallery.find(params[:id])
    @works = if params[:order_by] == 'newest' || params[:order_by].nil?
               @photogallery.works.ordered.page(page).per(per_page)
             else
               @photogallery.works.ordered_by_rating.page(page).per(per_page)
             end

    @photo_decorator = PhotogalleryDecorator.decorate(@photogallery)

    @photogallery.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
    render :partial => 'works/photogallery_list', :locals => { :current_count => current_count } and return if request.xhr?
  end

  def current_count
    total_count - (page.to_i * per_page)
  end

  def page
    params[:page] || 1
  end

  def per_page
    12
  end

  def total_count
    @photogallery.works.count
  end
end
