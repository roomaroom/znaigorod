class Manage::SectionPagesController < Manage::ApplicationController
  load_and_authorize_resource

  def create
    create!{
      redirect_to manage_organization_section_path(params[:organization_id], params[:section_id]) and return
    }
  end

  def update
    update!{
      redirect_to manage_organization_section_path(params[:organization_id], params[:section_id]) and return
    }
  end

  def destroy
    destroy!{
      redirect_to manage_organization_section_path(params[:organization_id], params[:section_id]) and return
    }
  end

  def build_resource
    Section.find(params[:section_id]).section_pages.new(params[:section_page])
  end

end
