HasSearcher.create_searcher(:activities) do
  models :activity
  scope { order_by(:activity_at, :desc) }

  property :activity do |search|
    if search_object.activity
      search.with(:activity_on).greater_than_or_equal_to(search_object.activity[:from]) if search_object.activity[:from].present?
      search.with(:activity_on).less_than_or_equal_to(search_object.activity[:to])      if search_object.activity[:to].present?
    end
  end

  property :state
  property :status
  property :kind
  property :user_id
end
