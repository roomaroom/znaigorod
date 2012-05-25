class AddVfsPathToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :vfs_path, :string
  end
end
