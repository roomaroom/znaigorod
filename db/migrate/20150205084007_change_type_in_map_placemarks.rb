class ChangeTypeInMapPlacemarks < ActiveRecord::Migration
  def change
    change_column :map_placemarks, :organization_title, :text
    change_column :map_placemarks, :organization_url, :text
    change_column :map_placemarks, :title, :text
    change_column :map_placemarks, :url, :text
  end
end
