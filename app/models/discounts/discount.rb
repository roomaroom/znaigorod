# encoding: utf-8

class Discount < ActiveRecord::Base
  attr_accessible :title, :description, :ends_at, :kind, :starts_at,
                  :discount, :payment_system, :organization_id, :type

  belongs_to :account
  belongs_to :organization

  validates_presence_of :title, :description, :kind, :starts_at, :ends_at

  extend Enumerize
  serialize :kind, Array
  enumerize :kind, :in => [:beauty, :entertainment, :sport], :multiple => true, :predicates => true
  enumerize :payment_system, :in => [:robokassa, :rbkmoney], :default => :robokassa

  extend FriendlyId
  friendly_id :title, use: :slugged
end
