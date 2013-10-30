class Prikupon::Importer
  attr_accessor :parser

  def initialize(data)
    @parser = Parser.new
  end

  def import
    if AffiliatedCoupon.find_by_origin_url(parser.json.links['product:view'])
      create_affiliated_coupon
    else
      update_affiliated_coupon
    end
  end

  private

  def create_affiliated_coupon
  end

  def update_affiliated_coupon
  end
end
