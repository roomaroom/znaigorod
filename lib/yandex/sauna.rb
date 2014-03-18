module Yandex
  class Sauna < Company
    def rubrics
      ['184106356']
    end

    def images
      super + suborganization.sauna_halls.flat_map(&:gallery_images)
    end

    private

    def steam_features
      [
        {
          :pass => proc { suborganization.offers.include?('русская парная') || suborganization.sauna_halls.select { |sh| sh.sauna_hall_bath.russian? }.any? },
          :success => { :name => 'steam', :value => 'russian_sauna' }
        },

        {
          :pass => proc { suborganization.offers.include?('турецкая парная') || suborganization.sauna_halls.select { |sh| sh.sauna_hall_bath.turkish? }.any? },
          :success => { :name => 'steam', :value => 'turkish_bath' }
        },

        {
          :pass => proc { suborganization.offers.include?('финская парная') || suborganization.sauna_halls.select { |sh| sh.sauna_hall_bath.finnish? }.any? },
          :success => { :name => 'steam', :value => 'finnish_sauna' }
        },

        {
          :pass => proc { suborganization.offers.include?('инфракрасная парная') || suborganization.sauna_halls.select { |sh| sh.sauna_hall_bath.infrared? }.any? },
          :success => { :name => 'steam', :value => 'infrared_sauna_2' }
        }
      ]
    end

    def service_rest_features
      [
        {
          :pass => proc { suborganization.features.include?('бильярдная') || suborganization.sauna_halls.select { |sh| sh.sauna_hall_entertainment.billiard? }.any? },
          :success => { :name => 'service_rest', :value => 'billiards_sauna' }
        },

        {
          :pass => proc { suborganization.features.include?('кальян') || suborganization.sauna_halls.select { |sh| sh.sauna_hall_entertainment.hookah? }.any? },
          :success => { :name => 'service_rest', :value => 'hookah_sauna' }
        },

        {
          :pass => proc { suborganization.sauna_halls.select { |sh| sh.sauna_hall_interior.pit? }.any? },
          :success => { :name => 'service_rest', :value => 'dance_floor_sauna' }
        },

        {
          :pass => proc { suborganization.sauna_halls.select { |sh| sh.sauna_hall_interior.pylon? }.any? },
          :success => { :name => 'service_rest', :value => 'runway_strip_sauna' }
        },

        {
          :pass => proc { suborganization.features.include?('караоке') || suborganization.sauna_halls.select { |sh| sh.sauna_hall_entertainment.karaoke? }.any? },
          :success => { :name => 'service_rest', :value => 'karaoke_sauna' }
        },

        {
          :pass => proc { suborganization.features.include?('кабельное тв') },
          :success => { :name => 'service_rest', :value => 'satellite_tv_sauna' }
        },

        {
          :pass => proc { suborganization.sauna_halls.select { |sh| sh.sauna_hall_entertainment.tv? }.any? },
          :success => { :name => 'service_rest', :value => 'audio_video_sauna' }
        },

        {
          :pass => proc { suborganization.sauna_halls.select { |sh| sh.sauna_hall_entertainment.ping_pong? }.any? },
          :success => { :name => 'service_rest', :value => 'ping_pong_sauna' }
        },

        {
          :pass => proc { suborganization.sauna_halls.select { |sh| sh.sauna_hall_entertainment.aerohockey? }.any? },
          :success => { :name => 'service_rest', :value => 'air_hockey_sauna' }
        },

        {
          :pass => proc { suborganization.features.include?('wi-fi') || suborganization.sauna_stuff.wifi? },
          :success => { :name => 'service_rest', :value => 'wifi_sauna' }
        }
      ]
    end

    def service_sauna_features
      [
        {
          :pass => proc { suborganization.sauna_broom.sale.present? },
          :success => { :name => 'service_sauna', :value => 'selection_brooms' }
        },

        {
          :pass => proc { suborganization.sauna_massage.classical.present? },
          :success => { :name => 'service_sauna', :value => 'massage_sauna' }
        },

        {
          :pass => proc { suborganization.sauna_massage.spa.present? },
          :success => { :name => 'service_sauna', :value => 'spa_procedures' }
        },
      ]
    end

    def water_stuff_features
      [
        {
          :pass => proc { suborganization.features.include?('бассейн') || suborganization.sauna_halls.select { |sh| sh.sauna_hall_pool }.any? },
          :success => { :name => 'water_stuff', :value => 'pool_sauna' }
        },

        {
          :pass => proc { suborganization.sauna_halls.select { |sh| sh.sauna_hall_pool.geyser? }.any? },
          :success => { :name => 'water_stuff', :value => 'geyser_sauna' }
        },

        {
          :pass => proc { suborganization.sauna_halls.select { |sh| sh.sauna_hall_pool.jacuzzi? }.any? },
          :success => { :name => 'water_stuff', :value => 'jacuzzi_sauna' }
        },

        {
          :pass => proc { suborganization.sauna_halls.select { |sh| sh.sauna_hall_pool.contraflow? }.any? },
          :success => { :name => 'water_stuff', :value => 'backflow_sauna' }
        },
      ]
    end

    def enum_multiple_features
      super + steam_features + service_rest_features + service_sauna_features + water_stuff_features
    end
  end
end
