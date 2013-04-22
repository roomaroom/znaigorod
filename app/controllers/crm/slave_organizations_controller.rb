class Crm::SlaveOrganizationsController < ApplicationController
  before_filter :check_permissions

  layout false

  def new
    @primary_organization = Organization.find(params[:primary_organization_id])

    render partial: 'crm/organizations/new_slave_organization'
  end

  def update
    @organization = Organization.find(params[:slave_organization][:primary_organization_id])

    if slave_organization = Organization.find_by_id(params[:id])
      slave_organization.update_attributes(params[:slave_organization])
    end

    render partial: 'crm/organizations/slave_organizations'
  end

  private

  def check_permissions
    ability = Ability.new(current_user)
    redirect_to manage_root_path unless ability.can?(:manage, :crm)
  end
end
