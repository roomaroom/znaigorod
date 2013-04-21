class Crm::SlaveOrganizationsController < ApplicationController
  load_and_authorize_resource class: Organization

  layout false

  def new
    @primary_organization = Organization.find(params[:primary_organization_id])

    render partial: 'crm/organizations/new_slave_organization'
  end

  def update
    slave_organization = Organization.find(params[:id])
    slave_organization.update_attributes(params[:slave_organization])
    @organization = slave_organization.primary_organization

    render partial: 'crm/organizations/slave_organizations'
  end
end
