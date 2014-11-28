class Manage::MapLayersController < Manage::ApplicationController
  load_and_authorize_resource

  def create
    create!{
      redirect_to manage_map_project_path(params[:map_project_id]) and return
    }
  end

  def update
    update!{
      redirect_to manage_map_project_path(params[:map_project_id]) and return
    }
  end

  def destroy
    destroy!{
      redirect_to manage_map_project_path(params[:map_project_id]) and return
    }
  end

  def build_resource
    MapProject.find(params[:map_project_id]).map_layers.new(params[:map_layer])
  end
end
