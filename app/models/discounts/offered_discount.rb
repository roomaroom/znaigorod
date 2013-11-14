class OfferedDiscount < Discount
  attr_accessible :placeholder

  has_many :offers, :as => :offerable

  # disable validation
  def sale?
    true
  end
end
