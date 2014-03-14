module Yandex
  class Company
    include Rails.application.routes.url_helpers

    attr_accessor :suborganization, :organization

    def initialize(suborganization)
      @suborganization = suborganization
      @organization = @suborganization.organization
    end

    delegate :title, :address, :email, :site, :logotype_url, :description,
      :to => :organization

    delegate :latitude, :longitude,
      :to => :address

    delegate :id, :to => :suborganization

    def country
      'Россия'
    end

    def admn_area
      'Томская область'
    end

    def locality_name
      'город Томск'
    end

    def rubrics
      []
    end

    def images
      []
    end

    def info_page
      organization.subdomain? ?
        "http://#{organization.subdomain}.#{Settings['app.host']}" :
        organization_url(organization, :host => Settings['app.host'])
    end

    def phones
      return [] unless organization.phone?

      organization.phone.split(',').map(&:squish)
        .map { |phone_number| phone_number.gsub(/[^\d]/, '') }
        .map { |phone_number| PhoneNumberNormalizer.new(phone_number).normalize }
    end

    def working_time
      grouped_schedules = organization.schedules.where(:holiday => false).inject([]) do |array, schedule|
        key = "#{I18n.l(schedule.from, :format => '%H:%M')}-#{I18n.l(schedule.to, :format => '%H:%M')}"

        key == array.last.try(:first) ? array.last.last << schedule : array << [key, [schedule]]

        array
      end

      return "ежедн. #{grouped_schedules.first.first}" if grouped_schedules.one? && grouped_schedules.flatten.size == 8

      array = grouped_schedules.map do |working_time, schedules|
        str = schedules.many? ?
          "#{schedules.first.short_human_day}-#{schedules.last.short_human_day} #{working_time}" :
          "#{schedules.first.short_human_day} #{working_time}"

        str.mb_chars.downcase.to_s
      end

      array.join(', ')
    end

    def actualization_date
      [suborganization.updated_at, organization.updated_at].max.to_i
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
