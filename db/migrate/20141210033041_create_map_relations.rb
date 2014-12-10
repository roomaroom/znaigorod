class CreateMapRelations < ActiveRecord::Migration
  def up
    create_table :map_relations, :id => false do |t|
      t.belongs_to :map_layer
      t.belongs_to :map_placemark
      t.timestamps
    end

    MapLayer.all.each do |ml|
      ml.map_placemarks = MapPlacemark.where(map_layer_id: ml.id)
      ml.save
    end

    remove_column :map_placemarks, :map_layer_id
  end

  def down
    drop_table :map_relations
    add_column :map_placemarks, :map_layer_id, :integer
  end
end
