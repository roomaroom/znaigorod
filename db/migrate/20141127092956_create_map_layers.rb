class CreateMapLayers < ActiveRecord::Migration
  def change
    create_table :map_layers do |t|
      t.string :title
      t.belongs_to :map_project
      t.string :slug
      t.string :image_url
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.timestamps
    end
  end
end
