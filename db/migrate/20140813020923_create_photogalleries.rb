class CreatePhotogalleries < ActiveRecord::Migration
  def change
    create_table :photogalleries do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.string :vfs_path
      t.text :og_description
      t.string :og_image_file_name
      t.string :og_image_content_type
      t.integer :og_image_file_size
      t.datetime :og_image_updated_at
      t.text :og_image_url
      t.text :agreement

      t.timestamps
    end
  end
end
