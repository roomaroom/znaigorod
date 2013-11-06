class Prikupon::Parser
  attr_reader :data

  def initialize(data = stub_data)
    @data = data
    check_type
  end

  def check_type
    raise Prikupon::UnknownTypeError, json_data.type if json_data.type != 'offer'
  end

  def json
    @json ||= Hashie::Mash.new(JSON.parse(data))
  end

  def json_data
    @json_data ||= json.data
  end

  delegate :title, :date_commences, :date_ends, :addresses, :supplier,
    :category_primary, :price_original, :coupon_price, :discount_percent,
    :coupons_limit, :picture_big,
    :to => :json_data

  def description
    @description ||= ActionController::Base.helpers.sanitize(json_data.description, :tags => %w[div p em ul li])
  end

  def terms
     @terms ||= Nokogiri::HTML(json_data.terms).css('li').map(&:text).map(&:squish)
  end

  def stub_data
    {
      'identity'             => 1283,
      'dates_format'         => 'ISO8601',
      'provider'             => 'provider',

      'data' => {
        'category_primary'   => 'здоровье',
        'category_secondary' => '',
        'coupon_price'       => '100.00',
        'coupons_limit'      => 10,
        'date_commences'     => '2013-09-12T00:00:00+02:00',
        'date_ends'          => '2013-10-12T00:00:00+02:00',
        'description'        => '<p><em>Антицеллюлитный массаж</em> представляет собой самый эффективный и безопасный способ борьбы с целлюлитом начальных стадий. Благодаря особым массажным техникам и интенсивному воздействию на проблемные зоны фигуры удается значительно усилить кровообращение в жировых тканях и, как результат, разрушить жировые отложения.</p><p><img class="lazy" src="/images/artwork/temp/city28/5/526f8bc6c719e.526f8bc6c71d7.jpg?8320" data-original="/images/artwork/temp/city17/5/526f8bc6c719e.526f8bc6c71d7.jpg?8320" style="height: 202px; width: 304px; display: inline;"><img class="lazy" src="/images/artwork/temp/city17/5/526f8bdd7bc76.526f8bdd7bcaf.jpg?8321" data-original="/images/artwork/temp/city17/5/526f8bdd7bc76.526f8bdd7bcaf.jpg?8321" style="height: 202px; width: 263px; display: inline;"></p><p><em>Классический антицеллюлитный массаж </em>является натуральным и эффективным способом моделирования фигуры и избавления от целлюлита. С его помощью Вы можете уменьшить бугристость целлюлитных зон без применения хирургических и аппаратных методик и при этом получить удовольствие!</p>',
        'discount_percent'   => 35,
        'picture_big'        => 'http://www.prikupon.com/images/offers/temp/city17/5/promoted/5231421720d09.5231421720d43.png',
        #'picture_big'        => 'http://www.seriouswheels.com/pics-1960-1969/1966-Pontiac-GTO-Red-fa-t-sy.jpg',                   # <=== cool car
        #'picture_big'        => 'http://www.albnews.al/wp-content/uploads/2013/08/99163-hot-girl_original.jpg',                    # <=== hot girl
        'picture_small'      => 'http://www.prikupon.com/images/offers/temp/city17/5/regular/5231421720d09.5231421720d43.jpg?5t3',
        'price_original'     => '1000.00',
        'terms'              => '<ul><li>Купон дает скидку 50% на курс из 5 процедур на антицеллюлитный массаж&nbsp;(продолжительность процедуры 50 минут)</li><li>Можно использовать несколько купонов</li><li>Обязательна предварительная запись по телефону: 8-909-544-64-55</li><li>Предъявлять VIP-карту или купон в распечатанном виде</li><li>Купоном можно воспользоваться до 30.11.2013</li></ul>',
        'title'              => 'product title text with single/double quotes',
        'type'               => 'offer',

        'addresses' => [
          'ул. Ив. Черных 83/1',
          'пр. Академический 14',
          'non existing address'
        ],

        'supplier' => {
          'title' => 'PR & Kupon',
          'link'  => 'http://www.prikupon.com/offers/1283#view-offer-cover',
          'logo'  => 'http://www.prikupon.com/images/logo_header.png'
        }
      },

      'links' => {
        'product:view'    => 'http://www.prikupon.com/offers/1283#view-offer-cover',
        'coupon:generate' => 'future-use'
      },

      'description_images' => [
        'http://www.seriouswheels.com/pics-1960-1969/1966-Pontiac-GTO-Red-fa-t-sy.jpg',
        'http://www.albnews.al/wp-content/uploads/2013/08/99163-hot-girl_original.jpg'
      ],

    }.to_json
  end
end
