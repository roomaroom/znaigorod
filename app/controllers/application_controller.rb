# encoding: utf-8

class ApplicationController < ActionController::Base
  helper_method :banners, :hot_offers

  layout 'public'

  protect_from_forgery

  protected
    def hot_offers
      all_offers[-6..-1]
    end

    def all_offers
      [
        'eatings/Пиццерии',
        'eatings/Завтраки',
        'eatings/Бизнес-Ланч',
        'eatings/Детские Кафе',
        'funnies/Бильярдные Залы',
        'eatings/Столовые',
        'eatings/Кофейни',
        'eatings/Wi-Fi',
        'funnies/Боулинг',
      ]
    end

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
