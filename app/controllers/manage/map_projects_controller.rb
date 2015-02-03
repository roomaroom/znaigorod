class Manage::MapProjectsController < Manage::ApplicationController
  load_and_authorize_resource

  def show
    show! {
      @map_placemarks = MapProject.find(params[:id]).map_layers.map(&:map_placemarks).flatten.uniq
    }
  end
end
