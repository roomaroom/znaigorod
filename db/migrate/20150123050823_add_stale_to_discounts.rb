class AddStaleToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :stale, :boolean
  end
end
