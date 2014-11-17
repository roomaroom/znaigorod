class BankiTomskController < ApplicationController
  helper_method :currency_filter, :metal_filter
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

  def currency_filter
    {}.tap {|hash|
      %w[usd_buy usd_sell euro_buy euro_sell].each do |filter|
        filter.split('_').include?('buy') ? hash[filter] = ['Покупка'] : hash[filter] = ['Продажа']
        params[:currency] == "#{filter} desc" ? hash[filter] += ['&darr;', filter] : hash[filter]+= ['&uarr;', "#{filter} desc"]
      end
    }
  end

  def metal_filter
    {}.tap {|hash|
      %w[gold_buy gold_sell silver_buy silver_sell platinum_buy platinum_sell palladium_buy palladium_sell].each do |filter|
        filter.split('_').include?('buy') ? hash[filter] = ['Покупка'] : hash[filter] = ['Продажа']
        params[:metal] == "#{filter} desc" ? hash[filter] += ['&darr;', filter] : hash[filter]+= ['&uarr;', "#{filter} desc"]
      end
    }
  end
end
