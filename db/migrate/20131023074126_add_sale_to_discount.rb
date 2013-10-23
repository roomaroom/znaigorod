class AddSaleToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :sale, :boolean, :default => false
  end
end
