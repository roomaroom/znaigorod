class AddVfsPathToSectionPage < ActiveRecord::Migration
  def change
    add_column :section_pages, :vfs_path, :string
  end
end
