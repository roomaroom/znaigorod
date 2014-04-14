class RoomsPresenter
  include ActiveAttr::MassAssignment
  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :hotel, filters: [:categories]

  attr_accessor :categories,
                :lat, :lon, :radius

  def initialize(args = {})
    super(args)

    normalize_arguments
  end

  def normalize_arguments
    @categories ||= []
  end

  def search
    Room.search do
      group :context_id

      with :categories, categories if categories.any?
      with :context_type, 'Hotel'
    end
  end

  def hotel_ids
    search.group(:context_id).groups.map(&:value)
  end

  def hotels
    Hotel.where(:id => hotel_ids).includes(:organization)
  end

  def collection
    hotels
  end

  def empty?
    search.total.zero?
  end

  def organizations
    hotels.map(&:organization)
  end

  def decorated_organizations
    OrganizationDecorator.decorate organizations
  end
end
