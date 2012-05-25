class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'public'
  helper_method :banners

  private
    def banners
      Affiche.with_images.with_showings.latest(4)
    end
end
