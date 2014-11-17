# encoding: utf-8
require 'store_currency_rates'
namespace :banki_tomsk do
  desc "Обновление курсов валют"
  task :update => :environment do
    StoreCurrencyRate.new.store_currency_rate
  end
end
