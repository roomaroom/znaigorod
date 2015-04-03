class Manage::SectionsController < Manage::ApplicationController
  load_and_authorize_resource

  def update
    update! {
      render :nothing => true and return
    }
  end

  def sort
    begin
      params[:position].each do |id, position|
        Section.find(id).update_attribute :position, position
      end
    rescue Exception => e
      render :text => e.message, :status => 500 and return
    end

    render :nothing => true, :status => 200
  end

  def destroy
    destroy! {
      redirect_to manage_organization_path(params[:organization_id]) and return
    }
  end
end
