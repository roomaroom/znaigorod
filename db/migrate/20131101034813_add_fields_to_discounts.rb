class AddFieldsToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :terms,    :text
    add_column :discounts, :supplier, :text
  end
end
