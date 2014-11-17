class BankiTomskController < ApplicationController
  def index
    xml = Nokogiri::XML(open('http://banki.tomsk.ru/export/vtomske_ru.php'))

    respond_to do |format|
      format.html{
        @exchange_rate = CurrencyRate.where('usd_buy IS NOT NULL').order(currency_order_param)
        @metals = CurrencyRate.where('gold_buy IS NOT NULL').order(metal_order_param)
      }

      format.promotion{
        @topkurs = xml.xpath('//topkurs').first.children.children.map{|topkurs| topkurs.text }
        render partial: 'promotions/banki_tomsk'
      }
    end
  end

  protected
  def currency_order_param
    return params[:currency] if params[:currency]
    'id'
  end

  def metal_order_param
    return params[:metals] if params[:metals]
    'id'
  end
end
