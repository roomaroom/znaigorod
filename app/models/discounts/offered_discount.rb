class OfferedDiscount < Discount
  attr_accessible :placeholder, :afisha_id

  belongs_to :afisha

  # disable validation
  def sale?
    true
  end

  delegate :clear, :to => :places, :prefix => true
  before_validation :places_clear, :if => :afisha_id?

  after_save :create_places, :if => :afisha_id?

  private

  def create_places_from_organizations_addresses
    afisha.organizations.each do |organization|
      places.create! :organization_id => organization.id, :address => organization.title,
        :latitude => organization.latitude, :longitude => organization.longitude
    end
  end

  def create_places_from_showings
    afisha.showings.pluck(:place).uniq.each do |place|
      geo_info = YampGeocoder.new.geo_info_for(place)
      places.create! :address => place, :longitude => geo_info.longitude, :latitude => geo_info.latitude
    end
  end

  def create_places
    places_clear

    afisha.organizations.any? ? create_places_from_organizations_addresses
      : create_places_from_showings
  end
end
