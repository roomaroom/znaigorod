class Manage::MapProjectsController < Manage::ApplicationController
  load_and_authorize_resource

  def show
    show!{
      @map_placemarks = MapPlacemark.offset(82) #TODO: как-то фиксить ннада
    }
  end
end
