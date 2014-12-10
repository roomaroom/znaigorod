class MapProjectsController < ApplicationController
  inherit_resources

  actions :show

  layout 'map_projects'

  def show
    show! {
      @map_placemarks = MapPlacemark.order('id desc')
      @presenter = ReviewsPresenter.new(category: 'newyear', per_page: 100)
      @reviews = @presenter.decorated_collection
    }
  end
end
