class RoomsPresenter
  class PriceFilter
    attr_accessor :price_min, :price_max

    def initialize(price_min, price_max)
      @price_min, @price_max = price_min, price_max
    end

    def price_min
      @price_min || available_price_min
    end

    def price_max
      @price_max || available_price_max
    end

    def available_price_min
      0
    end

    def available_price_max
      10000
    end
  end

  class CapacityFilter
    attr_accessor :capacity

    def initialize(capacity)
      @capacity = capacity
    end

    def capacity
      @capacity || capacity_min
    end

    def capacity_min
      1
    end

    def capacity_max
      100
    end
  end

  class RoomsFilter
    attr_accessor :rooms

    def initialize(rooms)
      @rooms = rooms
    end

    def rooms
      @rooms || rooms_min
    end

    def rooms_min
      1
    end

    def rooms_max
      100
    end
  end

  class HotelFeaturesFilter < Struct.new(:hotel_features)
  end

  class RoomFeatures < Struct.new(:room_features)
  end

  include ActiveAttr::MassAssignment
  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :hotel, filters: [:categories]

  attr_accessor :categories,
                :price_min, :price_max,
                :capacity,
                :rooms,
                :lat, :lon, :radius

  def initialize(args = {})
    super(args)

    normalize_arguments
  end

  def empty?
    context_id_group.total.zero?
  end

  def decorated_collection
    OrganizationDecorator.decorate organizations
  end

  def paginatable_collection
    context_id_groups
  end

  delegate :price_min, :price_max, :available_price_min, :available_price_max, :to => :price_filter
  delegate :capacity, :capacity_min, :capacity_max, :to => :capacity_filter
  delegate :rooms, :rooms_min, :rooms_max, :to => :rooms_filter

  private

  def normalize_arguments
    @categories ||= []
  end

  def search
    @search ||= Room.search(:include => { :context => :organization }) do
      group :context_id

      with :categories, categories if categories.any?
      with :context_type, 'Hotel'
    end
  end

  def context_id_group
    search.group(:context_id)
  end

  def context_id_groups
    context_id_group.groups
  end

  def hotel_ids
    context_id_groups.map(&:value)
  end

  def hotels
    Hotel.where(:id => hotel_ids).includes(:organization)
  end

  def collection
    organizations
  end

  def organizations
    hotels.map(&:organization)
  end

  def price_filter
    @price_filter ||= PriceFilter.new(@price_min, @price_max)
  end

  def capacity_filter
    @capacity_filter ||= CapacityFilter.new(@capacity)
  end

  def rooms_filter
    @rooms_filter ||= RoomsFilter.new(@rooms)
  end
end
