class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.references :placeable, :polymorphic => true
      t.string :address
      t.string :latitude
      t.string :longitude
      t.references :organization

      t.timestamps
    end
    add_index :places, :placeable_id
    add_index :places, :organization_id
  end
end
