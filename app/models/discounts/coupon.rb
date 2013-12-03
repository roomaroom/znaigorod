# encoding: utf-8

class Coupon < Discount
  include Copies
  include PaymentSystems

  attr_accessible :origin_price, :discounted_price, :price, :number

  validates_presence_of :origin_price, :price, :discounted_price, :number

  before_validation :set_discount

  def copies_for_sale?
    copies.for_sale.any?
  end

  private

  def set_discount
    self.discount = origin_price? ? ((1 - discounted_price.to_f / origin_price.to_f) * 100).round : 0
  end
end
