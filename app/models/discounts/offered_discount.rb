class OfferedDiscount < Discount
  attr_accessible :placeholder, :afisha_id

  belongs_to :afisha

  # disable validation
  def sale?
    true
  end

  before_validation :handle_before_validation

  after_create :create_places, :if => :afisha_id?

  private

  def handle_before_validation
    places.clear if new_record? && afisha_id?
  end

  def create_places_from_organizations_addresses
    afisha.organizations.each { |organization| places.create! :organization_id => organization.id }
  end

  def create_places_from_showings
    afisha.showings.pluck(:place).each do |place|
      geo_info = YampGeocoder.new.geo_info_for(place)
      places.create! :address => place, :longitude => geo_info.longitude, :latitude => geo_info.latitude
    end
  end

  def create_places
    afisha.organizations.any? ? create_places_from_organizations_addresses
      : create_places_from_showings
  end
end
