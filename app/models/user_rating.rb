class UserRating < ActiveRecord::Base
  attr_accessible :value

  belongs_to :user
  belongs_to :rateable, :polymorphic => true

  validates :value, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 4  }
  validates :user, :rateable, :presence => true
  validates :user_id, :uniqueness => { :scope => [:rateable_id, :rateable_type] }

  after_save :rateable_recalculate_rating

  private

  delegate :recalculate_rating, :to => :rateable, :prefix => true
end
