class Manage::SectionsController < Manage::ApplicationController
  load_and_authorize_resource

  def destroy
    destroy! {
      redirect_to manage_organization_path(params[:organization_id]) and return
    }
  end
end
