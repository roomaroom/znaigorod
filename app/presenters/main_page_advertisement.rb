# encoding: utf-8

class MainPageAdvertisement

  def initialize
    configuration = (YAML.load_file(Rails.root.join('config', 'advertisement.yml'))['main_page'] || {})
    @afisha_places = configuration['afisha'] || []
  end

  def afishas
    @places ||= {}.tap do |places|
      @afisha_places.each do |place, place_config|
        from, to = Time.zone.parse(place_config['from']), Time.zone.parse(place_config['to'])
        next if from >= Time.zone.now || to <= Time.zone.now
        places[place.to_i] = AfishaDecorator.find place_config['afisha_slug']
      end
    end
  end
end
