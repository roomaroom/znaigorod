class Offer < ActiveRecord::Base
  attr_accessible :details, :phone, :name, :amount, :state, :our_stake, :organization_stake

  belongs_to :account
  belongs_to :offerable, :polymorphic => true

  validates :phone, :presence => true, :format => { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }
  validates_presence_of :details, :name, :amount

  state_machine :state, :initial => :fresh do
    event(:approve) { transition :fresh => :approved }
    event(:cancel)  { transition :fresh => :canceled }
  end
end
