class CurrencyRate < ActiveRecord::Base
  attr_accessible :bank, :bank_link, :usd_sell, :usd_buy, :euro_sell, :euro_buy,
                  :gold_sell, :gold_buy, :silver_sell, :silver_buy,
                  :platinum_sell, :platinum_buy, :palladium_sell, :palladium_buy
end
