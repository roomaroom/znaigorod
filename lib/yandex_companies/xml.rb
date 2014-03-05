module YandexCompanies
  class Xml
    include Rails.application.routes.url_helpers

    attr_accessor :suborganizations

    def xml
      build_xml
    end

    private

    def suborganizations_with_organization
      suborganizations.inject({}) { |hash, suborganization| hash[suborganization] = suborganization.organization; hash }
    end

    def country
      'Россия'
    end

    def admn_area
      'Томская область'
    end

    def locality_name
      'город Томск'
    end

    def validated_url(url)
      url.match(/^http:\/\//) ?
        url :
        raise("Not valid url #{url}")
    end

    def info_page(organization)
      organization.subdomain? ?
        "http://#{organization.subdomain}.#{Settings['app.host']}" :
        organization_url(organization, :host => Settings['app.host'])

    end

    def actualization_date(suborganization)
      [suborganization.updated_at, suborganization.organization.updated_at].max.to_i
    end

    def car_park(suborganization)
      return nil unless suborganization.organization.organization_stand

      { :name => 'car_park', :value => '1' }
    end

    def payment_card(suborganization)
      return nil unless suborganization.organization.non_cash

      { :name => 'payment_method', :value => 'payment_card' }
    end

    def type_parking(suborganization)
      return nil unless suborganization.organization.organization_stand

      { :name => 'type_parking', :value => 'guarded_parking' } if suborganization.organization.organization_stand.guarded?
    end

    def features(suborganization)
      {}.tap do |features|

        features['feature-boolean'] = []
        features['feature-boolean'] << car_park(suborganization) if car_park(suborganization)

        features['feature-enum-multiple'] = []
        features['feature-enum-multiple'] << type_parking(suborganization) if type_parking(suborganization)
        features['feature-enum-multiple'] << payment_card(suborganization) if payment_card(suborganization)
      end
    end

    def build_xml
      @xml ||= begin
                 Nokogiri::XML::Builder.new :encoding => 'utf-8' do |xml|
                   xml.companies :version => '2.1', :'xmlns:xi' => 'http://www.w3.org/2001/XInclude' do |companies|

                     suborganizations_with_organization.each do |suborganization, organization|
                       companies.company do |company|
                         company.send :'company-id',                    organization.id
                         company.name(:lang => 'ru')                    { company.text organization.title }
                         company.address(:lang => 'ru')                 { company.text organization.address }
                         company.country(:lang => 'ru')                 { company.text country }
                         company.send(:'admn-area', :lang => 'ru')      { company.text admn_area }
                         company.send(:'locality-name', :lang => 'ru')  { company.text locality_name }

                         if organization.latitude.present? && organization.longitude.present?
                           company.coordinates do |coordinates|
                             coordinates.lat organization.latitude
                             coordinates.lon organization.longitude
                           end
                         end

                         # TODO: phones

                         company.email                 organization.email if organization.email?
                         company.url                   validated_url(organization.site) if organization.site?
                         company.send :'info-page',    info_page(organization)
                         # TODO: working time

                         rubrics.each do |rubric|
                           company.send :'rubric-id', rubric
                         end

                         company.send :'actualization-date', actualization_date(suborganization)
                         company.description                 organization.description if organization.description?

                         company.photos :'gallery-url' => organization_url(organization, :host => Settings['app.host']) do |photos|
                           photos.photo(:type => 'logo', :url => organization.logotype_url) if organization.logotype_url?

                           images(suborganization).each do |image|
                             photos.photo(:url => image.file_url)
                           end
                         end if organization.logotype_url? || images(suborganization).any?

                         features(suborganization).each do |feature_type, features_array|
                           features_array.each do |feature_attrs|
                             company.send feature_type, feature_attrs
                           end
                         end
                       end
                     end

                     xml.send :'xi:include', :href => known_features_href
                   end
                 end
               end
    end
  end
end
