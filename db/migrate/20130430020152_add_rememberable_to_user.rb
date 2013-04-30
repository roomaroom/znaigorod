class AddRememberableToUser < ActiveRecord::Migration
  def change
    add_column :users, :remember_created_at, :datetime
    add_column :users, :remember_token, :string
  end
end
