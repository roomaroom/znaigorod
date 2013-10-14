# encoding: utf-8

module SmsClaims
  extend ActiveSupport::Concern

  included do
    has_many :sms_claims, :as => :claimed, :dependent => :destroy

    has_one :reservation, :dependent => :destroy, :as => :reserveable

    delegate :enough_balance?, :sms_claimable?, :to => :organization
  end
end
