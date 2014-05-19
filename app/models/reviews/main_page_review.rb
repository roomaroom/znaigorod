class MainPageReview < ActiveRecord::Base
  attr_accessible :position, :review_id, :expires_at

  belongs_to :review

  scope :ordered, -> { order :position }
end
