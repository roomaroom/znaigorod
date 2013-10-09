class Coupon < ActiveRecord::Base
end

class PurgeCoupons < ActiveRecord::Migration
  def up
    drop_table :coupons
  end

  def down
  end
end
