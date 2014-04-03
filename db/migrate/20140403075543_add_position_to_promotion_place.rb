class AddPositionToPromotionPlace < ActiveRecord::Migration
  def change
    add_column :promotion_places, :position, :integer
  end
end
