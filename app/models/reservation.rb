class Reservation < ActiveRecord::Base
  attr_accessible :phone, :balance, :placeholder, :title

  belongs_to :reserveable, :polymorphic => true

  validates :phone, :presence => true, :format => { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }

  validates_presence_of :placeholder, :title

  after_initialize :set_default_title_and_placeholder, :if => :new_record?

  delegate :sunspot_index, :to => :reserveable, :prefix => true
  after_save :reserveable_index
  after_destroy :reserveable_index

  default_value_for :balance, 0

  def enough_balance?
    balance.present? && balance >= Settings['sms_claim.price']
  end

  private

  def set_default_title_and_placeholder
    self.title = I18n.t("sms_claim.#{reserveable.class.name.underscore}.link_title") if title.nil?
    self.placeholder = I18n.t("sms_claim.#{reserveable.class.name.underscore}.placeholder") if placeholder.nil?
  end
end
