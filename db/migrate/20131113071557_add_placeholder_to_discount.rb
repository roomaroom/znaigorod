class AddPlaceholderToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :placeholder, :text
  end
end
