class AffiliatedCoupon < Discount
  validates_presence_of :origin_url

  serialize :supplier, Hashie::Mash
  serialize :terms,    Array

  def actual?
    true
  end
end
