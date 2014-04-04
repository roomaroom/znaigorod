class DailyPrice < Price
  attr_accessible :value, :max_value, :day_kind

  validates_presence_of :value

  enumerize :day_kind, :in => [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
end
