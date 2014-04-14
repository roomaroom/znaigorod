class RoomsPresenter
  class CapacityFilter < Struct.new(:capacity)
  end

  include ActiveAttr::MassAssignment
  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :hotel, filters: [:categories]

  attr_accessor :categories,
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
end
