# encoding: utf-8

module SmsClaims
  extend ActiveSupport::Concern

  included do
    has_many :sms_claims, :as => :claimed, :dependent => :destroy

    has_one :reservation, :dependent => :destroy, :as => :reserveable
    delegate :title, :placeholder, :to => :reservation, :prefix => true
  end

  def sms_claimable?
    return false unless reservation

    reservation.phone? && reservation.enough_balance?
  end
end
