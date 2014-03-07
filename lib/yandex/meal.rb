module Yandex
  class Meal < Company
    def rubrics
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

    def images
      suborganization.organization.gallery_images +
        suborganization.gallery_images
    end

    private

    def cuisines_equivalence
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

    def cuisines_features
      cuisines_equivalence.inject([]) do |array, elem|
        yandex_value, our_value = elem.first, elem.last

        array <<  {
          :pass => proc { suborganization.cuisines.include?(our_value) },
          :success => { :name => 'type_cuisine', :value => yandex_value }
        }

        array
      end
    end

    def various_boolean_features
      [
        {
          :pass => proc { suborganization.features.include?('кальян') },
          :success => { :name => 'hookah', :value => '1' }
        },

        {
          :pass => proc { suborganization.features.include?('vip-зал') },
          :success => { :name => 'vip_room', :value => '1' }
        },

        {
          :pass => proc { suborganization.features.include?('бильярд') },
          :success => { :name => 'billiards', :value => '1' }
        },

        {
          :pass => proc { suborganization.features.include?('wi-fi') },
          :success => { :name => 'wi_fi', :value => '1' }
        },

        {
          :pass => proc { suborganization.features.include?('боулинг') },
          :success => { :name => 'bowling', :value => '1' }
        },

        {
          :pass => proc { suborganization.menus.flat_map(&:menu_positions).flat_map(&:position).include?('Бизнес ланч') },
          :success => { :name => 'business_lunch', :value => '1' }
        },

        {
          :pass => proc { suborganization.features.include?('спортивные трансляции') },
          :success => { :name => 'sports_broadcasts', :value => '1' }
        }
      ]
    end

    def games_features
      [
        {
          :pass => proc { suborganization.features.include?('нарды') },
          :success => { :name => 'type_board_games', :value => 'backgammon' }
        },

        {
          :pass => proc { suborganization.features.include?('шахматы') },
          :success => { :name => 'type_board_games', :value => 'chess' }
        },

        {
          :pass => proc { suborganization.features.include?('шашки') },
          :success => { :name => 'type_board_games', :value => 'checkers' }
        }
      ]
    end

    def boolean_features
      super + various_boolean_features
    end

    def enum_multiple_features
      super + cuisines_features + games_features
    end
  end
end

