class AddOrganizationIdToSports < ActiveRecord::Migration
  def change
    add_column :sports, :organization_id, :integer
  end
end
