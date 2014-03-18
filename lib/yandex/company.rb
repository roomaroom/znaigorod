module Yandex
  class Company

    attr_accessor :suborganization, :organization

    def initialize(suborganization)
      @suborganization = suborganization
      @organization = @suborganization.organization
    end

    def images
      organization.gallery_images + suborganization.gallery_images
    end

    def features
      hash = {}

      hash['feature-boolean'] = []
      boolean_features.each { |f| hash['feature-boolean'] << f[:success] if f[:pass].call }

      hash['feature-enum-multiple'] = []
      enum_multiple_features.each { |f| hash['feature-enum-multiple'] << f[:success] if f[:pass].call }

      hash
    end

    private

    def boolean_features
      [
        {
          :pass => proc { organization.organization_stand },
          :success => { :name => 'car_park', :value => '1' }
        }
      ]
    end

    def enum_multiple_features
      [
        {
          :pass => proc { organization.organization_stand.try :guarded? },
          :success => { :name => 'type_parking', :value => 'guarded_parking' }
        },

        {
          :pass => proc { organization.non_cash },
          :success => { :name => 'payment_method', :value => 'payment_card' }
        }
      ]
    end
  end
end
