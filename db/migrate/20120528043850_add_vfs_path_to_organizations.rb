class AddVfsPathToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :vfs_path, :string
  end
end
