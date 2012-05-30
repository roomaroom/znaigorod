class ApplicationController < ActionController::Base
  helper_method :banners

  layout 'public'

  protect_from_forgery

  protected
    def banners
      Affiche.with_images.with_showings.latest(4)
    end

    def page
      params[:page].blank? ? 1 : params[:page].to_i
    end

    def per_page
      @per_page ||= Settings['pagination.per_page'] || 10
    end

    def paginate_options
      {
        :page       => page,
        :per_page   => per_page
      }
    end
end
