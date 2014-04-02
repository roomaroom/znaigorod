class CreatePlaceItems < ActiveRecord::Migration
  def change
    create_table :place_items do |t|
      t.references :promotion_place
      t.string :url

      t.timestamps
    end
    add_index :place_items, :promotion_place_id
  end
end
