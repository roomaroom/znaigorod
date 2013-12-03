class ChangeDiscounts < ActiveRecord::Migration
  def up
    add_column :discounts, :external_id, :string
    replace_origin_url_with_external_id
    remove_column :discounts, :origin_url
  end

  def down
    remove_column :discounts, :external_id
    add_column :discounts, :origin_url, :string
  end

  private

  def external_id_from(url)
    match = case
    when url.match(%r{http://www\.prikupon\.com/index\.php/view/product/idProduct/}), url.match(%r{http://www\.prikupon\.com/view/product/idProduct/})
      url.match(/(\d+)#view-offer-cover/)
    when url.match(%r{http://prikupon\.com/offers/}), url.match(%r{http://www\.prikupon\.com/offers/})
      url.match(/\/offers\/(\d+)_/)
    else
      raise "Bad origin url: #{url}"
    end

    match.to_a.last
  end

  def replace_origin_url_with_external_id
    AffiliatedCoupon.find_each do |coupon|
      coupon.update_column :external_id, external_id_from(coupon.origin_url)
    end
  end
end
