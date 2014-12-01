class Manage::MapPlacemarksController < Manage::ApplicationController
  load_and_authorize_resource

  def new
    new!{
      @map_project = MapProject.find(params[:map_project_id])
    }
  end

  def edit
    edit!{
      @map_project = MapProject.find(params[:map_project_id])
    }
  end

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
end
