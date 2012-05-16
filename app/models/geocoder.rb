# encoding: utf-8

require 'curb'

class Geocoder
  def self.get_coordinates(street, house)
    address = "Томск, #{[street, house].join(', ')}"

    parameters = { :q => address, :version => '1.3', :key => Settings['2gis.api_key'], :output => 'json' }

    result = ['84.952222232222', '56.488611121111', 11]

    c = Curl::Easy.new("http://catalog.api.2gis.ru/geo/search?#{parameters.to_query}") do |curl|
      curl.on_success do |easy|
        response = JSON.parse(easy.body_str)
        if response['response_code'] == '200'
          result = response.try(:[], 'result').first['centroid'].match(/([0-9.]+\s?)+/)[0].split(' ')
        end
      end
    end

    c.perform if street.present?

    Hash[[:longitude, :latitude, :scale].zip(result)]
  end
end
