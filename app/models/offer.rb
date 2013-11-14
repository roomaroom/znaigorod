class Offer < ActiveRecord::Base
  attr_accessible :details, :phone, :name, :amount

  belongs_to :account
  belongs_to :offerable, :polymorphic => true

  validates :phone, :presence => true, :format => { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }
  validates_presence_of :details, :name, :amount
end
