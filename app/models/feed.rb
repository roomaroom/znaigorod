class Feed < ActiveRecord::Base
  attr_accessible :feedable, :account, :created_at, :updated_at
  belongs_to :feedable, :polymorphic => true
  belongs_to :account

  def message?
    (self.feedable.class.name == "InviteMessage" || self.feedable.class.name == "NotificationMessage" || self.feedable.class.name == "PrivateMessage")
  end

end

# == Schema Information
#
# Table name: feeds
#
#  id            :integer          not null, primary key
#  feedable_id   :integer
#  feedable_type :string(255)
#  account_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

