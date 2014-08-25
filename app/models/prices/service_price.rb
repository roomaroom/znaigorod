class ServicePrice < Price
  attr_accessible :kind, :value, :max_value, :count, :period, :description

  enumerize :kind, in: [:single, :multiple, :certificate], predicates: true

  validates_presence_of :kind, :value
  validates_presence_of :count, :period, :if => :multiple?
  validates_presence_of :count, :if => :certificate?

  def to_s
    "#{I18n.t("price_kind.#{kind}", count: count || 1)}"
  end
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

