module YandexCompanies
  class Meals < Xml
    def initialize
      @suborganizations = Meal.includes(
        :gallery_images,
        :menus => [:menu_positions],
        :organization => [:address, :gallery_images, :schedules]
      ).all
    end

    private

    def known_features_href
      'known-features_eda.xml'
    end

    def rubrics(suborganization)
      restaurants           = '184106394'
      cafe_and_coffee_shops = '184106390'
      pizzerias             = '184106392'
      pubs_bars             = '184106384'
      canteens              = '184106396'
      sushi_bars            = '1387788996'

      result = []

      result << restaurants           if suborganization.categories.include?('Рестораны')
      result << cafe_and_coffee_shops if (suborganization.categories & ['Кафе', 'Кофейни']).any?
      result << pizzerias             if suborganization.categories.include?('Пиццерии')
      result << pubs_bars             if suborganization.categories.include?('Бары')
      result << canteens              if suborganization.categories.include?('Столовые')
      result << sushi_bars            if suborganization.categories.include?('Суши-бары')

      return result[0..2] if result.any?

      [cafe_and_coffee_shops]
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

    def self.special_menu_data
      [
        {
          :pass => proc { |suborg| suborg.menus.flat_map(&:category).include? 'Выпечка' },
          :success => { :name => 'special_menu', :value => 'pancakes_menu' }
        },

        {
          :pass => proc { |suborg| suborg.features.include? 'вегетарианское меню' },
          :success => { :name => 'special_menu', :value => 'vegetarian_menu' }
        },

        {
          :pass => proc { |suborg| suborg.features.include? 'гриль-меню' },
          :success => { :name => 'special_menu', :value => 'grill_menu' }
        },

        {
          :pass => proc { |suborg| suborg.features.include? 'детское меню' },
          :success => { :name => 'special_menu', :value => 'childrens_menu' }
        }
      ]
    end

    def self.boolean_data
      [
        {
          :pass => proc { |suborg| suborg.features.include?('кальян') },
          :success => { :name => 'hookah', :value => '1' }
        },

        {
          :pass => proc { |suborg| suborg.features.include?('vip-зал') },
          :success => { :name => 'vip_room', :value => '1' }
        },

        {
          :pass => proc { |suborg| suborg.features.include?('бильярд') },
          :success => { :name => 'billiards', :value => '1' }
        },

        {
          :pass => proc { |suborg| suborg.features.include?('wi-fi') },
          :success => { :name => 'wi_fi', :value => '1' }
        },

        {
          :pass => proc { |suborg| suborg.features.include?('боулинг') },
          :success => { :name => 'bowling', :value => '1' }
        },

        {
          :pass => proc { |suborg| suborg.menus.flat_map(&:menu_positions).flat_map(&:category).include?('Бизнес ланч') },
          :success => { :name => 'business_lunch', :value => '1' }
        },

        {
          :pass => proc { |suborg| suborg.features.include?('спортивные трансляции') },
          :success => { :name => 'sports_broadcasts', :value => '1' }
        }
      ]
    end

    def self.games_data
      [
        {
          :pass => proc { |suborg| suborg.features.include?('нарды') },
          :success => { :name => 'type_board_games', :value => 'backgammon' }
        },

        {
          :pass => proc { |suborg| suborg.features.include?('шахматы') },
          :success => { :name => 'type_board_games', :value => 'chess' }
        },

        {
          :pass => proc { |suborg| suborg.features.include?('шашки') },
          :success => { :name => 'type_board_games', :value => 'checkers' }
        }
      ]
    end

    (special_menu_data + boolean_data + games_data).each do |e|
      define_method e[:success][:value] do |suborg|
        return e[:success] if e[:pass].call(suborg)

        nil
      end
    end

    def features(suborganization)
      super_features = super

      self.class.cuisines_data.each do |cuisine_type, _|
        super_features['feature-enum-multiple'] << send(cuisine_type, suborganization) if send(cuisine_type, suborganization)
      end

      (self.class.special_menu_data + self.class.games_data).each do |e|
        super_features['feature-enum-multiple'] << send(e[:success][:value], suborganization) if send(e[:success][:value], suborganization)
      end

      self.class.boolean_data.each do |e|
        super_features['feature-boolean'] << send(e[:success][:value], suborganization) if send(e[:success][:value], suborganization)
      end

      super_features
    end
  end
end

