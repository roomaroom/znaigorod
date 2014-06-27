class Webanketa < ActiveRecord::Base
  attr_accessible :expires_at, :text

  belongs_to :context, :polymorphic => true

  scope :actual, -> { where 'expires_at > ?', Time.zone.now }

  validates :text,       :presence => true
  validates :expires_at, :presence => true
end
