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
    end
    end

    begin
      c.perform if street.present?
    rescue
      return { response_code: 500 }
    end

    Hash[[:longitude, :latitude, :response_code].zip(result)]
  end

end
