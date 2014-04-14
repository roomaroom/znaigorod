class RoomsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories

  def initialize(args)
    super(args)

  end

  def kinds_links
    []
  end

  def collection_sms_claimable?
    false
  end

  def categories_links
    []
  end

  def search
    Room.search do
      group :context_id

      with :categories, categories
      with :context_type, 'Hotel'
    end
  end

  def hotels
    search.group(:context_id).groups.map(&:value).map { |hotel_id| Hotel.find(hotel_id)  }
  end
end
