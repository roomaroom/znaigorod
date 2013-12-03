class AffiliatedCoupon < Discount
  attr_accessible :external_id

  validates_presence_of :external_id

  serialize :supplier, Hashie::Mash
  serialize :terms,    Array

  def label_url
    URI(supplier.link).host
  end

  def type_for_solr
    'coupon'
  end

  def should_generate_new_friendly_id?
    true
  end
end
