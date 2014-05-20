class MainPageReview < ActiveRecord::Base
  attr_accessible :position, :review_id, :expires_at

  belongs_to :review

  scope :ordered, -> { order :position }
  scope :actual, -> { where 'expires_at > ?', Time.zone.now }
  scope :with_reviews, -> { where 'review_id IS NOT NULL' }

  scope :used, -> { actual.with_reviews.ordered }

  validates :expires_at, :presence => true

  def self.latest_reviews
    search = Review.search do
      order_by :created_at, :desc
      paginate :page => 1, :per_page => 3
      with :state, :published
      without used.map(&:review)
    end

    search.results
  end
end
