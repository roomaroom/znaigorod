class Offer < ActiveRecord::Base
  attr_accessible :details, :phone, :name, :amount, :state, :state_event, :our_stake, :organization_stake

  belongs_to :account
  belongs_to :offerable, :polymorphic => true

  has_many :messages, :dependent => :destroy, :as => :messageable

  has_one :sms, :dependent => :destroy, :as => :smsable
  has_one :offer_payment, :dependent => :destroy, :as => :paymentable

  validates :phone, :presence => true, :format => { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }
  validates_presence_of :details, :name, :amount
  validates_presence_of :our_stake, :organization_stake, :if => :approved?

  scope :by_state, ->(state) { where(:state => state) }

  searchable do
    string :state
    text :details
    text :title do offerable.title end

    time :created_at, :trie => true
  end

  state_machine :state, :initial => :fresh do
    event(:approve) { transition :fresh => :approved }
    event(:cancel)  { transition :fresh => :canceled }
    event(:pay)     { transition :approved => :paid }
  end

  def payment_system
    :robokassa
  end
end
