module YandexCompanies
  class Meals < Xml
    def initialize
      @suborganizations = Meal.includes(:gallery_images, :organization => [:address, :gallery_images, :schedules]).all
    end

    private

    def known_features_href
      'known-features_eda.xml'
    end

    def rubrics(suborganization)
      ['184106356']
    end

    def images(suborganization)
      suborganization.organization.gallery_images +
        suborganization.gallery_images
    end

    def self.cuisines_data
      {
        'authors_cuisine'     => 'Авторская',
        'asian_cuisine'       => 'Азиатская',
        'american_cuisine'    => 'Американская',
        'arabian_cuisine'     => 'Арабская',
        'vietnamese_cuisine'  => 'Вьетнамская',
        'hawaiian_cuisine'    => 'Гавайская',
        'georgian_cuisine'    => 'Грузинская',
        'european_cuisine'    => 'Европейская',
        'irish_cuisine'       => 'Ирландская',
        'italian_cuisine'     => 'Итальянская',
        'caucasian_cuisine'   => 'Кавказская',
        'chinese_cuisine'     => 'Китайская',
        'korean_cuisine'      => 'Корейская',
        'mexican_cuisine'     => 'Мексиканская',
        'russian_cuisine'     => 'Русская',
        'siberian_cuisine'    => 'Сибирская',
        'slavic_cuisine'      => 'Славянская',
        'thai_cuisine'        => 'Тайская',
        'tatar_cuisine'       => 'Татарская',
        'turkish_cuisine'     => 'Турецкая',
        'uzbek_cuisine'       => 'Узбекская',
        'japanese_cuisine'    => 'Японская',
      }
    end

    cuisines_data.each do |cuisine_type, value|
      define_method cuisine_type do |suborganization|
        return { :name => 'type_cuisine', :value => cuisine_type } if suborganization.cuisines.include?(value)

        nil
      end
    end

    def features(suborganization)
      super_features = super

      self.class.cuisines_data.each do |cuisine_type, _|
        super_features['feature-enum-multiple'] << send(cuisine_type, suborganization) if send(cuisine_type, suborganization)
      end

      super_features
    end
  end
end

