HasSearcher.create_searcher :reviews do
  models :review

  property :type
  property :category

  scope do
    with :state, :published
  end

  scope(:order_by_rating)     { order_by(:rating, :desc) }
  scope(:order_by_creation)   { order_by(:created_at, :desc) }
end

HasSearcher.create_searcher :similar_reviews do
  models :review
end
