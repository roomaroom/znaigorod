class MapLayersController < ApplicationController
  inherit_resources

  actions :show

  layout 'map_projects'

  def show
    show! {
      @presenter = ReviewsPresenter.new(category: 'newyear', per_page: 100)
      @reviews = @presenter.decorated_collection
    }
  end
end
