class Crm::SlaveOrganizationsController < ApplicationController
  before_filter :check_permissions

  layout false

  def new
    @primary_organization = Organization.find(params[:primary_organization_id])

    render partial: 'crm/organizations/new_slave_organization'
  end

  def update
    if slave_organization = Organization.find_by_id(params[:id])
      slave_organization.primary_organization_id = params[:primary_organization_id]
      slave_organization.save

    render partial: 'crm/organizations/slave_organization', locals: { slave_organization: slave_organization }
    else
      render nothing: true
    end
  end

  def destroy
    slave_organization = Organization.find(params[:id])
    slave_organization.primary_organization_id = nil
    slave_organization.save

    render nothing: true
  end

  private

  def check_permissions
    ability = Ability.new(current_user)
    redirect_to manage_root_path unless ability.can?(:manage, :crm)
  end
end
