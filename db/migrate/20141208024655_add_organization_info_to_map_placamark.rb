class AddOrganizationInfoToMapPlacamark < ActiveRecord::Migration
  def up
    add_column :map_placemarks, :organization_title, :string
    add_column :map_placemarks, :organization_url, :string
    remove_column :map_placemarks, :address

    MapPlacemark.all.each do |map_placemark|
      afisha_organization = map_placemark.relations.first.slave.try(:organization)
      if afisha_organization
        map_placemark.organization_title = afisha_organization.title
        map_placemark.organization_url = '/organizations/#{afisha_organization.slug}'
        map_placemark.save(:validate => false)
      end
    end
  end

  def down
    add_column :map_placemarks, :address, :string
    remove_column :map_placemarks, :organization_title, :organization_url
  end
end
