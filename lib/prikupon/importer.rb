class Prikupon::Importer
  attr_accessor :parser

  def initialize(data)
    @parser = Prikupon::Parser.new
  end

  def import
    if AffiliatedCoupon.find_by_origin_url(origin_url)
      find_affiliated_coupon
      set_attributes
      save_affiliated_coupon

      destroy_places
      destroy_gallery_images

      create_places
      create_gallery_image
    else
      build_affiliated_coupon
      set_attributes
      save_affiliated_coupon

      create_places
      create_gallery_image
    end

    affiliated_coupon
  end

  private

  def origin_url
    parser.json.links['product:view']
  end

  delegate :json, :to => :parser
  delegate :data, :to => :json, :prefix => true

  delegate :title, :description, :date_commences, :date_ends, :addresses,
    :price_original, :coupon_price, :discount_percent, :coupons_limit, :picture_big,
    :to => :json_data

  attr_accessor :affiliated_coupon

  def build_affiliated_coupon
    @affiliated_coupon = AffiliatedCoupon.new
    @affiliated_coupon.places = []
  end

  def set_attributes
    affiliated_coupon.title        = title
    affiliated_coupon.description  = description
    affiliated_coupon.kind         = ['beauty']                # <=== FAKE
    affiliated_coupon.origin_url   = origin_url

    affiliated_coupon.starts_at    = date_commences
    affiliated_coupon.ends_at      = date_ends

    affiliated_coupon.origin_price = price_original
    affiliated_coupon.price        = coupon_price
    affiliated_coupon.discount     = discount_percent
    affiliated_coupon.number       = coupons_limit
  end

  def save_affiliated_coupon
    affiliated_coupon.save!
  end

  def create_places
    addresses.each do |address|
      geo_info = YampGeocoder.new.geo_info_for(address)

      affiliated_coupon.places.create! :address => geo_info.address_line, :longitude => geo_info.longitude, :latitude => geo_info.latitude
    end
  end

  def create_gallery_image
    image_file = Tempfile.open(['affiliated_coupon', '.png']).tap do |tf|
      tf.binmode
      tf.write open(picture_big).read
    end

    gallery_image = affiliated_coupon.gallery_images.create!(:file => image_file)
    image_file.close!

    gallery_image
  end

  def find_affiliated_coupon
    @affiliated_coupon = AffiliatedCoupon.find_by_origin_url!(origin_url)
  end

  def destroy_places
    affiliated_coupon.places.destroy_all
  end

  def destroy_gallery_images
    affiliated_coupon.gallery_images.destroy_all
  end
end
