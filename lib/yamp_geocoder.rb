# encoding: utf-8

require 'curb'

class YampGeocoder


  def self.get_coordinates(street, house)
    address = ["город Томск", "Томская область", street, house].join(', ')

    parameters = { geocode: address, format: :json, results: 1 }

    result = [nil, nil]

    c = Curl::Easy.new("http://geocode-maps.yandex.ru/1.x/?#{parameters.to_query}") do |curl|
      curl.on_success do |easy|
      response = JSON.parse(easy.body_str)['response']['GeoObjectCollection']['featureMember'].first['GeoObject']
      result = response['Point']['pos'].split(' ')
      returned_house = response['name'].split(', ').last
      if returned_house.squish.eql?(house.squish)
        result << '200'
      else
        result << '404'
      end
      result << response['name']
      result << response['description']
    end
    end

    begin
      c.perform if street.present?
    rescue
      return { response_code: 500 }
    end

    Hash[[:longitude, :latitude, :response_code, :name, :description].zip(result)]
  end

  def self.get_object(query)
    address = ["Россия", "Томск", query].join(', ')
    coords = [84.94817, 56.490594].join(', ')
    parameters = { 
      text: address, 
      sll: coords, 
      vrb: '1', 
      perm: '1', 
      source: 'houses', 
      output: 'json' 
    }    
  end

  #should rewrite

  def self.get_addresses(query)
    
    parameters = get_object(query)
    

    result = {}
    
    c = Curl::Easy.new("http://maps.yandex.ru/?#{parameters.to_query}") do |curl|
      curl.on_success do |easy|
        result = JSON.parse(easy.body_str)
        if result['vpage']['data']['locations']['GeoObjectCollection']['features'][0]['properties']['GeocoderMetaData']['InternalToponymInfo']['houses'] != 0
          result = result['vpage']['data']['locations']['GeoObjectCollection']['features'][0]['properties']['GeocoderMetaData']['InternalToponymInfo']['Houses']
        else
          geometry = result['vpage']['data']['locations']['GeoObjectCollection']['features'][0]['properties']['GeocoderMetaData']['InternalToponymInfo']['Point']
          name = 1#result['vpage']['data']['locations']['GeoObjectCollection']['features'][0]['properties']['GeocoderMetaData']['AddressDetails']['Country']['Locality']['Thoroughfare']['Premise']['PremiseNumber']

          result = [{
              name: name,
              geometry: geometry
            }]
        end

      end
    end

    begin
      c.perform 
    rescue Exception => e
    end
    
    result
    
  end

  def self.get_addresses_count(query)

    parameters = get_object(query)

    result = {}
    
    c = Curl::Easy.new("http://maps.yandex.ru/?#{parameters.to_query}") do |curl|
      curl.on_success do |easy|
        result = JSON.parse(easy.body_str)
        if result['vpage']['data']['locations']['GeoObjectCollection']['features'][0]['properties']['GeocoderMetaData']['InternalToponymInfo']['houses'] != 0
          result = result['vpage']['data']['locations']['GeoObjectCollection']['features'][0]['properties']['GeocoderMetaData']['InternalToponymInfo']['Houses'].size
        else
          result = 1
        end
      end
    end

    begin
      c.perform 
    rescue Exception => e
    end
    
    result
    
  end

end
