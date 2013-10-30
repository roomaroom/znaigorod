class Prikupon::Parser
  attr_reader :json

  def initialize(data = stub_data)
    @json = Hashie::Mash.new(JSON.parse(data))
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
        #'picture_big'        => 'http://www.prikupon.com/images/offers/temp/city17/5/promoted/5231421720d09.5231421720d43.png',
        'picture_big'        => 'http://www.albnews.al/wp-content/uploads/2013/08/99163-hot-girl_original.jpg',
        #'picture_big'        => 'http://www.seriouswheels.com/pics-1960-1969/1966-Pontiac-GTO-Red-fa-t-sy.jpg',
        'picture_small'      => 'http://www.prikupon.com/images/offers/temp/city17/5/regular/5231421720d09.5231421720d43.jpg?5t3',
        'price_original'     => '1000.00',
        'terms'              => 'product conditions text with html tags',
        'title'              => 'product title text with single/double quotes',
        'type'               => 'offer',

        'addresses' => [
          'ул. Ив. Черных 83/1',
          'пр. Академический 14',
          'non existing address'
        ]
      },

      'links' => {
        'product:view'       => 'http://www.prikupon.com/offers/1283#view-offer-cover',
        'coupon:generate'    => 'future-use'
      }
    }.to_json
  end
end
