class AddConstantToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :constant, :boolean
  end
end
