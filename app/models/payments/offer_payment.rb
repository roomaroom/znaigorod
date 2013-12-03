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

# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  paymentable_id   :integer
#  number           :integer
#  phone            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  paymentable_type :string(255)
#  type             :string(255)
#  amount           :float
#  details          :text
#  state            :string(255)
#  email            :string(255)
#

