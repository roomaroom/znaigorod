class AddPrimaryOrganizationIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :primary_organization_id, :integer
  end
end
