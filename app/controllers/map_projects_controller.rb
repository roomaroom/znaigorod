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
        @map_placemarks = MapProject.find(params[:id]).map_layers.map(&:map_placemarks).flatten.uniq
      end
      @reviews = ReviewDecorator.decorate(MapProject.find(params[:id]).relations.map(&:slave))
    }
  end
end
