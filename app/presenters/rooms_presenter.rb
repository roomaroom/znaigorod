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

  class HotelFeaturesFilter
    attr_accessor :hotel_features

    def initialize(hotel_features)
      @hotel_features = hotel_features
    end
  end

  class Feature
    attr_accessor :title

    def initialize(title, selected)
      @title, @selected = title, selected
    end

    def selected?
      @selected
    end
  end

  class RoomFeaturesFilter
    attr_accessor :room_features

    def initialize(room_features)
      @room_features = room_features || []
    end

    def room_features
      available_room_features.map do |title|
        Feature.new title, @room_features.include?(title)
      end
    end

    def used?
      room_features.delete_if(&:blank?).any?
    end

    def css_class
      used? ? 'used' : 'not_used'
    end

    private

    def available_room_features
      %w[foo bar baz qux]
    end
  end

  class HotelFeaturesFilter
    attr_accessor :hotel_features

    def initialize(hotel_features)
      @hotel_features = hotel_features || []
    end

    def hotel_features
      available_hotel_features.map do |title|
        Feature.new title, @hotel_features.include?(title)
      end
    end

    def used?
      hotel_features.delete_if(&:blank?).any?
    end

    def css_class
      used? ? 'used' : 'not_used'
    end

    private

    def available_hotel_features
      %w[ololo pysh rialni]
    end
  end

  include ActiveAttr::MassAssignment
  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :hotel, filters: [:categories]

  attr_accessor :categories,
                :price_min, :price_max,
                :capacity,
                :rooms,
                :room_features,
                :hotel_features,
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
  delegate :room_features, :to => :room_features_filter
  delegate :hotel_features, :to => :hotel_features_filter

  def room_features_filter_css_class
    room_features_filter.css_class
  end

  def hotel_features_filter_css_class
    room_features_filter.css_class
  end

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

  def room_features_filter
    @room_features_filter = RoomFeaturesFilter.new(@room_features)
  end

  def hotel_features_filter
    @hotel_features_filter = HotelFeaturesFilter.new(@hotel_features)
  end
end
