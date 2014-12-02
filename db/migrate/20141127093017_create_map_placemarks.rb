class CreateMapPlacemarks < ActiveRecord::Migration
  def change
    create_table :map_placemarks do |t|
      t.string :title
      t.float :latitude
      t.float :longitude
      t.string :image_url
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.string :url
      t.string :address
      t.string :when
      t.belongs_to :map_layer
      t.timestamps
    end
  end
end
