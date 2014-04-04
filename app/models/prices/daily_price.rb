class DailyPrice < Price
  attr_accessible :kind, :value, :max_value, :count, :period, :description

  validates_presence_of :value
end
