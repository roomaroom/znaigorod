class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :kind
      t.integer :value
      t.integer :count
      t.string :period
      t.references :service

      t.timestamps
    end
    add_index :prices, :service_id
  end
end
