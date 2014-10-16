class PhotogalleriesController < ApplicationController
  include ImageHelper
  helper_method :page, :per_page, :current_count, :total_count

  def index
    respond_to do |format|
      format.html {
        @photogalleries = Photogallery.order('id desc')
        @photo_decorator = PhotogalleryDecorator.decorate(@photogalleries)
      }

      format.promotion {
        render :partial => 'promotions/photogalleries', :locals => { :photogalleries => Photogallery.order('id desc').limit(3)  }
      }
    end
  end

  def show
    respond_to do |format|
      format.html {
        @photogallery = Photogallery.find(params[:id])
        @works = if params[:order_by] == 'newest' || params[:order_by].nil?
                   @photogallery.works.ordered_by_id.page(page).per(per_page)
                 else
                   @photogallery.works.ordered_by_rating.page(page).per(per_page)
                 end

        @photo_decorator = PhotogalleryDecorator.decorate(@photogallery)

        @photogallery.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
        render :partial => 'works/photogallery_list', :locals => { :current_count => current_count } and return if request.xhr?
      }

      format.promotion {
        render :partial => 'promotions/photogallery', :locals => { :photogallery => Photogallery.find(params[:id]) }
      }
    end
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

  def photogallery_collection
    searcher = HasSearcher.searcher(:photogalleries, :q => params[:q])
      .order_by_title
      .paginate(page: params[:page], per_page: 12)

    photogalleries = {}

    searcher.results.each do |photogallery|
      hash_info = {}.tap{ |info|
        info['image'] = resized_image_url(photogallery.image_url, 66, 87)
        info['title'] = photogallery.title
        info['url'] = photogallery_url(photogallery)
        info['prefix'] = 'photogallery'
      }
      photogalleries[photogallery.id] = hash_info
    end


    render json: photogalleries.to_json, :callback => params['callback']
  end

  def single_photogallery
    photogallery = Photogallery.find(params[:id])

    single_photogallery = {}.tap{ |single|
      single['image'] = photogallery.works.limit(6).map{ |work| resized_image_url(work.image_url, 234, 158) }
      single['published_at'] = photogallery.created_at
      single['title'] = photogallery.title
      single['url'] = photogallery_url(photogallery)
    }

    render json: single_photogallery.to_json
  end
end
