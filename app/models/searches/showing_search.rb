class ShowingSearch < Search
  attr_accessible :categories,
                  :keywords,
                  :price_gt,
                  :price_lt,
                  :starts_at_gt,
                  :starts_at_hour_gt,
                  :starts_at_hour_lt,
                  :starts_on_gt,
                  :starts_on_lt,
                  :tags

  column :categories,         :string
  column :keywords,           :text
  column :price_gt,           :integer
  column :price_lt,           :integer
  column :starts_at_gt,       :datetime
  column :starts_at_hour_gt,  :integer
  column :starts_at_hour_lt,  :integer
  column :starts_on_gt,       :date
  column :starts_on_lt,       :date
  column :tags,               :string

  default_value_for :price_gt,          0
  default_value_for :starts_at_hour_gt, 0
  default_value_for :starts_at_hour_lt, 24
  default_value_for(:starts_on_gt)      { Date.today }
end
