class Prikupon::Importer
  attr_accessor :parser

  def initialize(data)
    @parser = Prikupon::Parser.new(data)
  end

  def import
    safe_import
  end

  private

  def origin_url
    parser.json.links['product:view']
  end

  delegate :json, :description, :terms, :to => :parser
  delegate :data, :to => :json, :prefix => true

  delegate :title, :date_commences, :date_ends, :addresses, :supplier,
    :category_primary, :price_original, :coupon_price, :discount_percent,
    :coupons_limit, :picture_big,
    :to => :json_data

  attr_accessor :affiliated_coupon

  def build_affiliated_coupon
    @affiliated_coupon = AffiliatedCoupon.new
    @affiliated_coupon.places = []
  end

  def set_attributes
    affiliated_coupon.title        = title
    affiliated_coupon.description  = description
    affiliated_coupon.kind         = [Prikupon::Categories.new(category_primary).kind]
    affiliated_coupon.origin_url   = origin_url

    affiliated_coupon.starts_at    = date_commences
    affiliated_coupon.ends_at      = date_ends

    affiliated_coupon.origin_price = price_original
    affiliated_coupon.price        = coupon_price
    affiliated_coupon.discount     = discount_percent
    affiliated_coupon.number       = coupons_limit

    affiliated_coupon.supplier     = supplier
    affiliated_coupon.terms        = terms

    affiliated_coupon.state       = :published
  end

  def save_affiliated_coupon
    affiliated_coupon.save! :validate => false
    set_slug
  end

  def set_slug
    affiliated_coupon.send(:set_slug)
  end

  def create_places
    addresses.each do |address|
      geo_info = YampGeocoder.new.geo_info_for(address)

      affiliated_coupon.places.create! :address => geo_info.address_line, :longitude => geo_info.longitude, :latitude => geo_info.latitude
    end
  end

  def remove_poster
    affiliated_coupon.poster_url       = nil
    affiliated_coupon.poster_image_url = nil

    affiliated_coupon.poster_image.destroy
  end

  def save_poster
    image_file = Tempfile.open(['affiliated_coupon', '.png']).tap do |tf|
      tf.binmode
      tf.write open(picture_big).read
    end

    affiliated_coupon.poster_image = image_file
    affiliated_coupon.save! :validate => false
    image_file.close!

    affiliated_coupon.poster_url = affiliated_coupon.poster_image_url
    affiliated_coupon.save! :validate => false

    affiliated_coupon
  end

  def find_affiliated_coupon
    @affiliated_coupon = AffiliatedCoupon.find_by_origin_url!(origin_url)
  end

  def destroy_places
    affiliated_coupon.places.destroy_all
  end

  def safe_import
    ActiveRecord::Base.transaction do
      if AffiliatedCoupon.find_by_origin_url(origin_url)
        find_affiliated_coupon
        set_attributes
        save_affiliated_coupon

        remove_poster
        save_poster

        destroy_places
        create_places
      else
        build_affiliated_coupon
        set_attributes
        save_affiliated_coupon

        remove_poster
        save_poster

        create_places
      end

      affiliated_coupon
    end
  end
end
