class AddEmailsToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :email_addresses, :text
  end
end
