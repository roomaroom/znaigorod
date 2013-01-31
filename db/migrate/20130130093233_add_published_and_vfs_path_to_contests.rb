class AddPublishedAndVfsPathToContests < ActiveRecord::Migration
  def change
    add_column :contests, :published, :boolean
    add_column :contests, :vfs_path, :string
  end
end
