class Coupon < ActiveRecord::Base
end

class PurgeCoupons < ActiveRecord::Migration
  def up
    Coupon.destroy_all

    drop_table :coupons
  end

  def down
  end
end
