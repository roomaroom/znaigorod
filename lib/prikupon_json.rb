class PrikuponJson
  attr_accessor :data

  def initialize(data)
    @data = stub_data
  end

  def discount
    Discount.new do |discount|
      discount.title            = json.data.title
      discount.description      = json.data.description
      discount.kind             = ['KIND']

      discount.starts_at        = json.data.date_commences
      discount.ends_at          = json.data.date_ends
      discount.place            = 'PLACE'

      discount.number           = json.data.coupons_limit
      discount.origin_price     = json.data.price_original
      discount.discounted_price = discounted_price
      discount.price            = json.data.coupon_price
    end
  end

  private

  def discounted_price
    json.data.price_original.to_f - json.data.price_original.to_f * json.data.discount_percent.to_f / 100.0
  end

  def json
    Hashie::Mash.new JSON.parse(data)
  end

  def stub_data
    {
      'identity'             => 1283,
      'dates_format'         => 'ISO8601',

      'data' => {
        'category_primary'   => 'здоровье',
        'category_secondary' => '',
        'coupon_price'       => '100.00',
        'coupons_limit'      => 10,
        'date_commences'     => '2013-09-12T00:00:00+02:00',
        'date_ends'          => '2013-10-12T00:00:00+02:00',
        'description'        => 'product description text with html tags',
        'discount_percent'   => 35,
        'picture_big'        => 'http://www.prikupon.com/images/offers/temp/city17/5/promoted/5231421720d09.5231421720d43.png',
        'picture_small'      => 'http://www.prikupon.com/images/offers/temp/city17/5/regular/5231421720d09.5231421720d43.jpg?5t3',
        'price_original'     => '1000.00',
        'terms'              => 'product conditions text with html tags',
        'title'              => 'product title text with single/double quotes',
        'type'               => 'offer',
        },

      'links' => {
        'product:view'       => 'http://www.prikupon.com/offers/1283#view-offer-cover',
        'coupon:generate'    => 'future-use'
      }
    }.to_json
  end
end
