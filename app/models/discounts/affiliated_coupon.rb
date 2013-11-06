class AffiliatedCoupon < Discount
  validates_presence_of :origin_url

  serialize :supplier, Hashie::Mash
  serialize :terms,    Array

  def actual?
    true
  end

  def label_url
    URI(origin_url).host
  end

  def type_for_solr
    'coupon'
  end
end
