class CreateCurrencyRates < ActiveRecord::Migration
  def change
    create_table :currency_rates do |t|
      t.string :bank
      t.float :usd_sell
      t.float :usd_buy
      t.float :euro_sell
      t.float :euro_buy
      t.float :gold_sell
      t.float :gold_buy
      t.float :silver_sell
      t.float :silver_buy
      t.float :platinum_sell
      t.float :platinum_buy
      t.float :palladium_sell
      t.float :palladium_buy
      t.timestamps
    end
  end
end
