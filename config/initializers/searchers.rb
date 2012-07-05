HasSearcher.create_searcher :total do
  models :affiche, :eating, :funny
  keywords :q

  scope do
    any_of do
      with(:last_showing_time).greater_than(DateTime.now)
      with(:kind, :organization)
    end
  end
end

HasSearcher.create_searcher :showing do
  models :showing

  property :affiche_id
  property :starts_on, :modificators => [:greater_than, :less_than]

  scope :actual do
    with(:starts_at).greater_than DateTime.now
  end

  scope :today do
    with(:starts_at).less_than DateTime.now.end_of_day
  end

  scope :faceted do
    facet(:tags)
  end
end
