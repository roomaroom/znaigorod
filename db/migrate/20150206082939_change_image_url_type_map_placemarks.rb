class ChangeImageUrlTypeMapPlacemarks < ActiveRecord::Migration
  def change
    change_column :map_placemarks, :image_url, :text
  end
end
