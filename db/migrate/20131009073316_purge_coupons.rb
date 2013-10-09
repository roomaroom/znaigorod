class Coupon < ActiveRecord::Base
end

class PurgeCoupons < ActiveRecord::Migration
  def up
    drop_table :coupons

    coupon_copies = Copy.where(:copyable_type => 'Coupon')
    coupon_copies.destroy_all
  end

  def down
  end
end
