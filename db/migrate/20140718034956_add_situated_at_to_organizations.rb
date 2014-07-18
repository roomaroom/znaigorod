class AddSituatedAtToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :situated_at, :integer
  end
end
