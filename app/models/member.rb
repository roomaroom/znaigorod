class Member < ActiveRecord::Base
  belongs_to :memberable, :polymorphic => true
  belongs_to :account

  has_one :feed, :as => :feedable, :dependent => :destroy

  validates_uniqueness_of :account_id, :scope => [:memberable_id, :memberable_type]

  after_create :create_feed

  def create_feed
    Feed.create(
      :feedable => self,
      :account => self.account,
      :created_at => self.created_at,
      :updated_at => self.updated_at
    )
  end

end

# == Schema Information
#
# Table name: members
#
#  id              :integer          not null, primary key
#  memberable_id   :integer
#  memberable_type :string(255)
#  account_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

