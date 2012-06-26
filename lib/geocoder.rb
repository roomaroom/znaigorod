# encoding: utf-8

require 'curb'

class Geocoder
  def self.get_coordinates(street, house)
    address = [street, house].join(', ')

    parameters = { :q => address, :version => '1.3', :key => Settings['2gis.api_key'], :output => 'json', :project => 3, :types => 'street,house,place', :limit => 50 }

    result = ['84.952222232222', '56.488611121111']

    c = Curl::Easy.new("http://catalog.api.2gis.ru/geo/search?#{parameters.to_query}") do |curl|
      curl.on_success do |easy|
        response = JSON.parse(easy.body_str)
        if response['response_code'] == '200'
          default_rank = response.try(:[], 'result').try(:count)
          hits = response.try(:[], 'result').inject({}) do |hash, hit|
            rank = hit.try(:[], 'attributes').try(:[], 'rank') || (default_rank -= 1)
            hash[rank.to_i] = hit.try(:[], 'centroid')
            hash
          end
          result = hits[hits.keys.sort.last].match(/([0-9.]+\s?)+/)[0].split(' ')
        end
        result << response['response_code']
      end
    end

    c.perform if street.present?

    Hash[[:longitude, :latitude, :response_code].zip(result)]
  end
end
