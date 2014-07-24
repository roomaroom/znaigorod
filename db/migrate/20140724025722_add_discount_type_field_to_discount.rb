class AddDiscountTypeFieldToDiscount < ActiveRecord::Migration
  def up
    add_column :discounts, :discount_type, :string
    Discount.where('type IS NULL').update_all(:discount_type => :percentages)
  end

  def down
    remove_column :discounts, :discount_type
  end
end
