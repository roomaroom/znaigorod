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
      ['184106356']
    end

    def images(suborganization)
      suborganization.organization.gallery_images +
        suborganization.gallery_images +
        suborganization.sauna_halls.flat_map(&:gallery_images)
    end

    def self.methods_data
      [
        {
          :method => :offers, :method_value => 'русская парная', :associaction => :sauna_hall_bath, :associaction_method => :russian?,
          :success => { :name => 'steam', :value => 'russian_sauna' }
        },

        {
          :method => :offers, :method_value => 'турецкая парная', :associaction => :sauna_hall_bath, :associaction_method => :turkish?,
          :success => { :name => 'steam', :value => 'turkish_bath' }
        },

        {
          :method => :offers, :method_value => 'финская парная', :associaction => :sauna_hall_bath, :associaction_method => :finnish?,
          :success => { :name => 'steam', :value => 'finnish_sauna' }
        },

        {
          :method => :offers, :method_value => 'инфракрасная парная', :associaction => :sauna_hall_bath, :associaction_method => :infrared?,
          :success => { :name => 'steam', :value => 'infrared_sauna_2' }
        },

        {
          :method => :features, :method_value => 'бильярдная', :associaction => :sauna_hall_entertainment, :associaction_method => :billiard?,
          :success => { :name => 'service_rest', :value => 'billiards_sauna' }
        },

        {
          :method => :features, :method_value => 'кальян', :associaction => :sauna_hall_entertainment, :associaction_method => :hookah?,
          :success => { :name => 'service_rest', :value => 'hookah_sauna' }
        },

        {
          :associaction => :sauna_hall_interior, :associaction_method => :pit?,
          :success => { :name => 'service_rest', :value => 'dance_floor_sauna' }
        },

        {
          :associaction => :sauna_hall_interior, :associaction_method => :pylon?,
          :success => { :name => 'service_rest', :value => 'runway_strip_sauna' }
        },

        {
          :method => :features, :method_value => 'караоке', :associaction => :sauna_hall_entertainment, :associaction_method => :karaoke?,
          :success => { :name => 'service_rest', :value => 'karaoke_sauna' }
        },

        {
          :method => :features, :method_value => 'кабельное тв',
          :success => { :name => 'service_rest', :value => 'satellite_tv_sauna' }
        },

        {
          :associaction => :sauna_hall_entertainment, :associaction_method => :tv?,
          :success => { :name => 'service_rest', :value => 'audio_video_sauna' }
        },

        {
          :associaction => :sauna_hall_entertainment, :associaction_method => :ping_pong?,
          :success => { :name => 'service_rest', :value => 'ping_pong_sauna' }
        },

        {
          :associaction => :sauna_hall_entertainment, :associaction_method => :aerohockey?,
          :success => { :name => 'service_rest', :value => 'air_hockey_sauna' }
        },

        {
          :method => :features, :method_value => 'wi-fi', :associaction => proc { |suborganization| suborganization.sauna_stuff.wifi? },
          :success => { :name => 'service_rest', :value => 'wifi_sauna' }
        },

        {
          :associaction => proc { |suborganization| suborganization.sauna_broom.sale.present? },
          :success => { :name => 'service_sauna', :value => 'selection_brooms' }
        },

        {
          :associaction => proc { |suborganization| suborganization.sauna_massage.classical.present? },
          :success => { :name => 'service_sauna', :value => 'massage_sauna' }
        },

        {
          :associaction => proc { |suborganization| suborganization.sauna_massage.spa.present? },
          :success => { :name => 'service_sauna', :value => 'spa_procedures' }
        },

        {
          :method => :features, :method_value => 'бассейн', :associaction => :sauna_hall_pool, :associaction_method => :present?,
          :success => { :name => 'water_stuff', :value => 'pool_sauna' }
        },

        {
          :associaction => :sauna_hall_pool, :associaction_method => :geyser?,
          :success => { :name => 'water_stuff', :value => 'geyser_sauna' }
        },

        {
          :associaction => :sauna_hall_pool, :associaction_method => :jacuzzi?,
          :success => { :name => 'water_stuff', :value => 'jacuzzi_sauna' }
        },

        {
          :associaction => :sauna_hall_pool, :associaction_method => :contraflow?,
          :success => { :name => 'water_stuff', :value => 'backflow_sauna' }
        },
      ]
    end

    methods_data.each do |e|
      define_method e[:success][:value] do |suborganization|
        if e[:method]
          return e[:success] if suborganization.send(e[:method]).include?(e[:method_value])
        end

        case e[:associaction]
        when Symbol
          suborganization.sauna_halls.each { |sh| return e[:success] if sh.send(e[:associaction]).send(e[:associaction_method]) }
        when Proc
          return e[:success] if e[:associaction].call(suborganization)
        end

        nil
      end
    end

    def features(suborganization)
      super_features = super

      self.class.methods_data.each do |e|
        super_features['feature-enum-multiple'] << send(e[:success][:value], suborganization) if send(e[:success][:value], suborganization)
      end

      super_features
    end
  end
end
