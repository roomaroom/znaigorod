# encoding: utf-8

class Ticket < ActiveRecord::Base
  extend Enumerize

  include Copies
  include PaymentSystems
  include EmailNotifications

  attr_accessible :number, :original_price, :price, :description, :short_description,
    :stale_at, :organization_price, :undertow

  belongs_to :afisha

  validates_presence_of :number, :original_price, :price, :description, :stale_at

  scope :for_stale, -> { where "stale_at <= ? AND (state = 'for_sale' OR state IS NULL)", Time.zone.now }
  scope :for_sale, -> { where("stale_at >= ? AND (state = 'for_sale' OR state IS NULL)", Time.zone.now) }
  scope :stale, -> { by_state 'stale' }
  scope :without_report, -> { where :report_sended => false }

  alias_attribute :message_for_sms, :description

  def organization
    afisha(:include => { :showings => :organizatiob }).showings.first.try(:organization)
  end

  delegate :title, :to => :afisha, :prefix => true
  delegate :title, :to => :organization, :prefix => true, :allow_nil => true

  enumerize :state,
    :in => [:for_sale, :stale],
    :default => :for_sale,
    :predicates => true

  searchable do
    text :afisha_title
    text :organization_title
  end

  default_value_for :short_description, 'Купить билет'

  def stale!
    update_attribute :state, 'stale'
    copies.map(&:stale!)
  end

  def discount
    ((original_price - (organization_price.to_f + price)) * 100 / original_price).round
  end

  def free?
    false
  end

  def title_for_list
    short_description? ? short_description : description
  end
end

# == Schema Information
#
# Table name: tickets
#
#  id                 :integer          not null, primary key
#  afisha_id          :integer
#  number             :integer
#  original_price     :float
#  price              :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  description        :text
#  stale_at           :datetime
#  organization_price :float
#  email_addresses    :text
#  undertow           :integer
#  state              :string(255)
#  payment_system     :string(255)
#  short_description  :string(255)
#

