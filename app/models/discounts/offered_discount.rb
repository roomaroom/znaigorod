class OfferedDiscount < Discount
  attr_accessible :placeholder

  # disable validation
  def sale?
    true
  end
end
