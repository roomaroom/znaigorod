class CreateMapPlacemarks < ActiveRecord::Migration
  def change
    create_table :map_placemarks do |t|
      t.string :title
      t.float :latitude
      t.float :longitude
      t.string :image_url
      t.string :url
      t.belongs_to :map_layer
      t.timestamps
    end
  end
end
