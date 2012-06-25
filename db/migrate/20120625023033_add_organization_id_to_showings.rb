class AddOrganizationIdToShowings < ActiveRecord::Migration
  def change
    add_column :showings, :organization_id, :integer
  end
end
