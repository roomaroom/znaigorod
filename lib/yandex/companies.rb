module Yandex
  class Companies
    def xml
      build.to_xml
    end

    private

    def build
      @build ||= begin
                   pb = ProgressBar.new(companies.size)

                   Nokogiri::XML::Builder.new :encoding => 'utf-8' do |xml|
                     xml.companies :version => '2.1', :'xmlns:xi' => 'http://www.w3.org/2001/XInclude' do |xml_companies|
                       companies.each do |company|
                         pb.increment!

                         # TODO: set rubrics for all companies
                         next if company.rubrics.empty?

                         xml_companies.company do |xml_company|
                           xml_company.send :'company-id',                    company.id
                           xml_company.name(:lang => 'ru')                    { xml_company.text company.title }
                           xml_company.address(:lang => 'ru')                 { xml_company.text company.address }
                           xml_company.country(:lang => 'ru')                 { xml_company.text company.country }
                           xml_company.send(:'admn-area', :lang => 'ru')      { xml_company.text company.admn_area }
                           xml_company.send(:'locality-name', :lang => 'ru')  { xml_company.text company.locality_name }

                           if company.address && company.latitude.present? && company.longitude.present?
                             xml_company.coordinates do |xml_coordinates|
                               xml_coordinates.lat company.latitude
                               xml_coordinates.lon company.longitude
                             end
                           end

                           xml_company.email               company.email if company.email.present?
                           xml_company.url                 company.site  if company.site.present?
                           xml_company.send :'info-page',  company.info_page

                           company.phones.each do |phone|
                             xml_company.phone do |xml_phone|
                               xml_phone.ext    nil
                               xml_phone.type   'phone'
                               xml_phone.number phone
                             end
                           end

                           # TODO: phones
                           # TODO: working time

                           company.rubrics.each do |rubric|
                             xml_company.send :'rubric-id', rubric
                           end

                           xml_company.send :'actualization-date', company.actualization_date
                           xml_company.description                 company.description if company.description.present?

                           xml_company.photos :'gallery-url' => company.info_page do |xml_photos|
                             xml_photos.photo(:type => 'logo', :url => company.logotype_url) if company.logotype_url.present?

                             company.images.each do |image|
                               xml_photos.photo(:url => image.file_url)
                             end
                           end if company.logotype_url.present? || company.images.any?

                           company.features.each do |tag, attributes_list|
                             attributes_list.each do |attributes|
                               xml_company.send tag, attributes
                             end
                           end
                         end
                       end

                       xml.send :'xi:include', :href => 'known-features_saunas_ru.xml'
                       xml.send :'xi:include', :href => 'known-features_eda.xml'
                     end
                   end
                 end
    end

    def saunas
      ::Sauna.includes(

        :gallery_images,
        :sauna_stuff,
        :sauna_broom,
        :sauna_massage,
        :organization => [:address, :gallery_images, :schedules, :organization_stand],
        :sauna_halls => [:gallery_images, :sauna_hall_entertainment, :sauna_hall_interior, :sauna_hall_bath],

      ).all.map { |s| Yandex::Sauna.new(s) }
    end

    def meals
      ::Meal.all.map { |s| Yandex::Meal.new(s) }
    end

    def entertainments
      ::Entertainment.all.map { |s| Yandex::Entertainment.new(s) }
    end

    def cultures
      ::Culture.all.map { |s| Yandex::Culture.new(s) }
    end

    def creations
      ::Creation.all.map { |s| Yandex::Culture.new(s) }
    end

    def billiards
      ::Billiard.all.map { |s| Yandex::Billiard.new(s) }
    end

    def sports
      ::Sport.all.map { |s| Yandex::Sport.new(s) }
    end

    def companies
      @companies ||= meals + saunas + entertainments + cultures + creations + billiards + sports
    end
  end
end
