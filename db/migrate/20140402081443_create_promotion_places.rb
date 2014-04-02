class CreatePromotionPlaces < ActiveRecord::Migration
  def change
    create_table :promotion_places do |t|
      t.references :promotion

      t.timestamps
    end
    add_index :promotion_places, :promotion_id
  end
end
