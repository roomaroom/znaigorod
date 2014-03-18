module Yandex
  class Companies
    def xml
      build.to_xml
    end

    private

    def build
      @build ||= begin
                   pb = ProgressBar.new(organizations.size)

                   Nokogiri::XML::Builder.new :encoding => 'utf-8' do |xml|
                     xml.companies :version => '2.1', :'xmlns:xi' => 'http://www.w3.org/2001/XInclude' do |xml_companies|
                       organizations.each do |organization|
                         pb.increment!

                         # TODO: set rubrics for all companies
                         next if organization.rubrics.empty?

                         xml_companies.company do |xml_company|
                           xml_company.send :'company-id',                    organization.id
                           xml_company.name(:lang => 'ru')                    { xml_company.text organization.title }
                           xml_company.address(:lang => 'ru')                 { xml_company.text organization.address }
                           xml_company.country(:lang => 'ru')                 { xml_company.text organization.country }
                           xml_company.send(:'admn-area', :lang => 'ru')      { xml_company.text organization.admn_area }
                           xml_company.send(:'locality-name', :lang => 'ru')  { xml_company.text organization.locality_name }

                           if organization.address && organization.latitude.present? && organization.longitude.present?
                             xml_company.coordinates do |xml_coordinates|
                               xml_coordinates.lat organization.latitude
                               xml_coordinates.lon organization.longitude
                             end
                           end

                           xml_company.email               organization.email if organization.email.present?
                           xml_company.url                 organization.site  if organization.site.present?
                           xml_company.send :'info-page',  organization.info_page

                           organization.phones.each do |phone|
                             xml_company.phone do |xml_phone|
                               xml_phone.ext    nil
                               xml_phone.info   nil
                               xml_phone.number phone
                               xml_phone.type   'phone'
                             end
                           end

                           xml_company.send :'working-time', organization.working_time

                           organization.rubrics.each do |rubric|
                             xml_company.send :'rubric-id', rubric
                           end

                           xml_company.send :'actualization-date', organization.actualization_date
                           xml_company.description                 organization.description if organization.description.present?

                           xml_company.photos :'gallery-url' => organization.info_page do |xml_photos|
                             xml_photos.photo(:type => 'logo', :url => organization.logotype_url) if organization.logotype_url.present?

                             organization.images.each do |image|
                               xml_photos.photo(:url => image.file_url)
                             end
                           end if organization.logotype_url.present? || organization.images.any?

                           organization.features.each do |tag, attributes_list|
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

    def organizations
      @organizations ||= ::Organization.all
        .map { |o| Yandex::Organization.new(o) }
    end
  end
end
