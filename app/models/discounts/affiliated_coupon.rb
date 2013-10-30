class AffiliatedCoupon < Discount
  validates_presence_of :origin_url

  def actual?
    true
  end
end
