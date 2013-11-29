class OfferedDiscount < Discount
  attr_accessible :placeholder, :afisha_id

  belongs_to :afisha

  # disable validation
  def sale?
    true
  end

  before_validation :handle_before_validation

  after_create :create_places, :if => :afisha_id?

  def handle_before_validation
    if afisha_id?
      places.clear
    end
  end

  def create_places
    if afisha.organizations.any?
      afisha.organizations.each { |o| places.create! :organization_id => o.id }
    else

    end
  end
end
