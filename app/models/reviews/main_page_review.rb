class MainPageReview < ActiveRecord::Base
  attr_accessible :position, :review_id, :expires_at

  belongs_to :review

  scope :ordered, -> { order :position }
  scope :actual, -> { where 'expires_at > ?', Time.zone.now }
  scope :with_reviews, -> { where 'review_id IS NOT NULL' }

  scope :used, -> { actual.with_reviews.ordered }

  validates :expires_at, :presence => true

  def self.latest_reviews
    Review.published.order('created_at DESC').where('id NOT IN (?)', used.pluck(:id)).limit(3)
  end
end
