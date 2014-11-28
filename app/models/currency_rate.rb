class CurrencyRate < ActiveRecord::Base
  attr_accessible :bank, :bank_link, :usd_sell, :usd_buy, :euro_sell, :euro_buy,
                  :gold_sell, :gold_buy, :silver_sell, :silver_buy,
                  :platinum_sell, :platinum_buy, :palladium_sell, :palladium_buy
end

# == Schema Information
#
# Table name: currency_rates
#
#  id             :integer          not null, primary key
#  bank           :string(255)
#  bank_link      :string(255)
#  usd_sell       :float
#  usd_buy        :float
#  euro_sell      :float
#  euro_buy       :float
#  gold_sell      :float
#  gold_buy       :float
#  silver_sell    :float
#  silver_buy     :float
#  platinum_sell  :float
#  platinum_buy   :float
#  palladium_sell :float
#  palladium_buy  :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

