class AddMoneyFieldsToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :our_stake, :integer
    add_column :offers, :organization_stake, :integer
  end
end
