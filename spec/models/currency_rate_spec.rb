require 'spec_helper'

describe CurrencyRate do
  pending "add some examples to (or delete) #{__FILE__}"
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

