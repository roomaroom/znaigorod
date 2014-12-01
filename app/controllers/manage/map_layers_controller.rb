class Manage::MapLayersController < Manage::ApplicationController
  load_and_authorize_resource

  def create
    create! do |success, failure|
      success.html { redirect_to manage_map_project_path(resource.map_project)}
      failure.html { render :new }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to manage_map_project_path(resource.map_project)}
      failure.html { render :edit }
    end
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
