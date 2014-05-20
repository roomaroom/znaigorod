class MainPageReview < ActiveRecord::Base
  attr_accessible :position, :review_id, :expires_at

  belongs_to :review

  scope :ordered, -> { order :position }
  scope :actual, -> { where 'expires_at > ?', Time.zone.now }
  scope :with_reviews, -> { where 'review_id IS NOT NULL' }

  scope :used, -> { actual.with_reviews.ordered }

  validates :expires_at, :presence => true
end
