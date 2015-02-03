class AddClusterIconToMapProjects < ActiveRecord::Migration
  def change
    add_column :map_projects, :cluster_icon_url, :string
    add_column :map_projects, :cluster_icon_file_name, :string
    add_column :map_projects, :cluster_icon_content_type, :string
    add_column :map_projects, :cluster_icon_file_size, :string
  end
end
