class AddAfishaIdToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :afisha_id, :integer
    add_index :discounts, :afisha_id
  end
end
