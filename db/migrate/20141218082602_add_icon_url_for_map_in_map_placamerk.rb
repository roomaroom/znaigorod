class AddIconUrlForMapInMapPlacamerk < ActiveRecord::Migration
  def change
    add_column :map_layers, :icon_image_url, :string
    add_column :map_layers, :icon_image_file_name, :string
    add_column :map_layers, :icon_image_content_type, :string
    add_column :map_layers, :icon_image_file_size, :string
  end
end
