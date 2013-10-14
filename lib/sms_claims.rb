# encoding: utf-8

module SmsClaims
  extend ActiveSupport::Concern

  included do
    has_many :sms_claims, :as => :claimed, :dependent => :destroy

    has_one :reservation, :dependent => :destroy, :as => :reserveable
  end

  def sms_claimable?
    return false unless reservation

    reservation.phone? && reservation.enough_balance?
  end
end
