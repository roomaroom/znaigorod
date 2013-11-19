# encoding: utf-8

require 'payments/payment'

class OfferPayment < Payment
  attr_accessible :phone

  has_one :sms, :as => :smsable

  delegate :message, :to => :paymentable

  def approve!
    super
    paymentable.pay!
    create_sms! :phone => phone, :message => message
  end
end

