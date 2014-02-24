HasSearcher.create_searcher :reviews do
  models :review

  property :type
  property :category

  scope do
    with :state, :published
  end

  scope :without_eighteen_plus do
    without :category, :eighteen_plus
  end

  scope(:order_by_rating)     { order_by(:rating, :desc) }
  scope(:order_by_creation)   { order_by(:created_at, :desc) }
end
