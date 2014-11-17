require 'open-uri'

class StoreCurrencyRate
  def initialize

  end

  def store_currency_rate
    xml = Nokogiri::XML(open('http://banki.tomsk.ru/export/vtomske_ru.php'))

    exchange_rate = {}.tap { |hash|
      xml.xpath('//banki/bank').each do |node|
        currency_info = node.child.children.children.map{ |kurs| kurs.text }
        hash[node.attribute('name').value] = { "usd_buy" => currency_info[0], "usd_sell" => currency_info[1], "euro_buy" => currency_info[2], "euro_sell" => currency_info[3] }
      end

      xml.xpath('//metal/bank').each do |node|
        metal_info = node.children.children.map{ |metal| metal.text }
        hash[node.attribute('name').value] = { "gold_buy" => metal_info[0], "gold_sell" => metal_info[1], "silver_buy" => metal_info[2], "silver_sell" => metal_info[3], "platinum_buy" => metal_info[4], "platinum_sell" => metal_info[5], "palladium_buy" => metal_info[6], "palladium_sell" => metal_info[7]}
      end
    }

    exchange_rate.each do |key, value|
      bank = CurrencyRate.where(bank: key).first || CurrencyRate.create(bank: key)
      bank.update_attributes(value)
    end

  end
end
