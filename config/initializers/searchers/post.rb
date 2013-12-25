HasSearcher.create_searcher :posts_new do
  models :post

  property :kind

  scope do
    with :state, :published
  end

  scope(:order_by_rating)     { order_by(:rating, :desc) }
  scope(:order_by_creation)   { order_by(:created_at, :desc) }
end

HasSearcher.create_searcher :similar_posts do
  models :post
end
