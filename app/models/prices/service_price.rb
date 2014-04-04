class ServicePrice < Price
  extend Enumerize

  attr_accessible :kind, :value, :max_value, :count, :period, :description

  enumerize :kind, in: [:single, :multiple, :certificate], predicates: true

  validates_presence_of :kind, :value
  validates_presence_of :count, :period, :if => :multiple?
  validates_presence_of :count, :if => :certificate?

  def to_s
    "#{I18n.t("price_kind.#{service.kind}", count: count || 1)}"
  end
end
