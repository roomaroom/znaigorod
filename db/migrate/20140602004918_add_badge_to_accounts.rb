class AddBadgeToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :badge, :text
  end
end
