class MapProjectsController < ApplicationController
  inherit_resources

  actions :show

  layout 'map_projects'

  def show
    show! {
      if params[:layer]
        @map_layer = MapLayer.find(params[:layer])
        @map_placemarks = @map_layer.map_placemarks
      else
        @map_placemarks = MapPlacemark.all
      end
      @reviews = ReviewsPresenter.new(category: 'newyear', per_page: 100).decorated_collection
    }
  end
end
