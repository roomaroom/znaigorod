class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :account
      t.references :offerable, :polymorphic => true
      t.string :phone
      t.text :details
      t.integer :amount
      t.string :name

      t.timestamps
    end
    add_index :offers, :account_id
    add_index :offers, :offerable_id
  end
end
