class DailyPrice < Price
  attr_accessible :value, :max_value, :day_kind

  validates_presence_of :value

  scope :ordered, order('day_kind')

  enumerize :day_kind, :in => [1,2,3,4,5,6,7]
end
