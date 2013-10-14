class Reservation < ActiveRecord::Base
  attr_accessible :phone, :balance, :placeholder, :title

  belongs_to :reserveable, :polymorphic => true

  validates_presence_of :phone, :placeholder, :title

  after_initialize :set_default_title_and_placeholder, :if => :new_record?

  default_value_for :balance, 0

  private

  def set_default_title_and_placeholder
    self.title = I18n.t("sms_claim.#{reserveable.class.name.underscore}.link_title") if title.nil?
    self.placeholder = I18n.t("sms_claim.#{reserveable.class.name.underscore}.placeholder") if placeholder.nil?
  end
end
