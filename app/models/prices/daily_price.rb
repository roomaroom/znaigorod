class DailyPrice < Price
  attr_accessible :value, :max_value, :day_kind

  validates_presence_of :value

  scope :ordered, order('day_kind')

  enumerize :day_kind, :in => [1,2,3,4,5,6,7]
end

# == Schema Information
#
# Table name: prices
#
#  id           :integer          not null, primary key
#  kind         :string(255)
#  value        :integer
#  count        :integer
#  period       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  description  :string(255)
#  max_value    :integer
#  type         :string(255)
#  context_id   :integer
#  context_type :string(255)
#  day_kind     :string(255)
#

