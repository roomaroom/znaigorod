class Feed < ActiveRecord::Base
  attr_accessible :feedable, :account, :created_at, :updated_at
  belongs_to :feedable, :polymorphic => true
  belongs_to :account

  def self.feeds_for_presenter(searcher_params)
    self.where(searcher_params).includes(:feedable).order('created_at DESC')
  end

  def friend_name_for_feed_friend
    name = ""
    name += self.feedable.friendable.first_name if self.feedable.friendable.first_name.present?
    name += " "
    name += self.feedable.friendable.last_name  if self.feedable.friendable.last_name.present?
    name
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

