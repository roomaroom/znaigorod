# encoding: utf-8

class Coupon < Discount
  validates_presence_of :number, :payment_system
end
