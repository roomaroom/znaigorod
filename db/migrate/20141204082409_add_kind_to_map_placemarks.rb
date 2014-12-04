class AddKindToMapPlacemarks < ActiveRecord::Migration
  def up
    add_column :map_placemarks, :kind, :string
    MapPlacemark.all.each do |map_placemark|
      map_placemark.kind = map_placemark.relations.first.try(:slave_type).to_s.downcase.presence || 'custom'
      map_placemark.save(:validation => false)
    end
  end

  def down
    remove_column :map_placemarks, :kind
  end
end
