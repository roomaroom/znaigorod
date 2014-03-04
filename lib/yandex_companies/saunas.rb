module YandexCompanies
  class Saunas < Xml
    def initialize
      @suborganizations = Sauna.includes(:gallery_images, :organization => [:address, :gallery_images, :schedules]).all
    end

    private

    def known_features_href
      'known-features_saunas_ru.xml'
    end

    def rubrics
      [1, 2, 3]
    end

    def features(suborganization)
      features = {}

      features['feature-boolean'] = []
      features['feature-boolean'] << car_park(suborganization) if car_park(suborganization)

      features['feature-enum-multiple'] = []
      features['feature-enum-multiple'] << type_parking(suborganization) if type_parking(suborganization)

      features
    end
  end
end
