class RelatedItemsController < ApplicationController
  def afishas
    settings_from_cookie = {}
    settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?

    @presenter = AfishaPresenter.new(settings_from_cookie.merge(params))
  end

  def organizations

  end

  def reviews

  end
end
