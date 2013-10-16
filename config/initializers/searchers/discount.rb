HasSearcher.create_searcher :discounts do
  models :discount

  property :type

  #property :kind do |search|
    #search.with(:kind, search_object.kind) if search_object.kind.try(:present?)
  #end

  scope(:order_by_rating)   { order_by(:rating, :desc) }
  scope(:order_by_creation) { order_by(:created_at, :desc) }
end

HasSearcher.create_searcher :similar_discount do
  models :discount

  scope do
    with(:ends_at).greater_than HasSearcher.cacheable_now
  end
end
