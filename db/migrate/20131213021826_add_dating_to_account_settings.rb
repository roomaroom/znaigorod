class AddDatingToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :dating, :boolean, default: true
  end
end
