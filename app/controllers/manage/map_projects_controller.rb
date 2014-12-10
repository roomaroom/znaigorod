class Manage::MapProjectsController < Manage::ApplicationController
  load_and_authorize_resource

  def show
    show!{
      @map_placemarks = MapPlacemark.order('id desc')
    }
  end
end
