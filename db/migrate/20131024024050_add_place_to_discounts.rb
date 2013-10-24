class AddPlaceToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :place, :string
  end
end
