class PrikuponJson
  def parse
    create_discount
    create_places
    create_gallery_image
  end


  def create_discount
    @discount ||= AffiliatedCoupon.new do |discount|
      discount.title        = json.data.title
      discount.description  = json.data.description
      discount.kind         = ['beauty']                # <=== FAKE

      discount.starts_at    = json.data.date_commences
      discount.ends_at      = json.data.date_ends

      discount.origin_price = json.data.price_original
      discount.price        = json.data.coupon_price
      discount.discount     = json.data.discount_percent
      discount.number       = json.data.coupons_limit
    end

    @discount.save!
  end

  def create_places
    json.data.addresses.each do |address|
      geo_info = YampGeocoder.new.geo_info_for(address)

      @discount.places.create! :address => geo_info.address_line, :longitude => geo_info.longitude, :latitude => geo_info.latitude
    end
  end

  def tempfile_image
    @tempfile = Tempfile.open(['affiliated_coupon', '.png']).tap do |tf|
      tf.binmode
      tf.write open(json.data.picture_big).read
    end

    @tempfile
  end

  def create_gallery_image
    @discount.gallery_images.create! :file => tempfile_image

    tempfile_image.close!
  end

end
