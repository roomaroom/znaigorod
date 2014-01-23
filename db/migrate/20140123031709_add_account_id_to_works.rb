class AddAccountIdToWorks < ActiveRecord::Migration
  def change
    add_column :works, :account_id, :integer
    add_index :works, :account_id
  end
end
