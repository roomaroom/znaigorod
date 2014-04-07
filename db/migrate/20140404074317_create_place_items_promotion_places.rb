class CreatePlaceItemsPromotionPlaces < ActiveRecord::Migration
  def change
    create_table :place_items_promotion_places do |t|
      t.belongs_to :place_item
      t.belongs_to :promotion_place
    end
    remove_column :place_items, :promotion_place_id
  end
end
