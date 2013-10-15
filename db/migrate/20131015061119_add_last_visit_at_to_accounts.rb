class AddLastVisitAtToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :last_visit_at, :datetime
  end
end
