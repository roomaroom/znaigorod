class MainPageReview < ActiveRecord::Base
  attr_accessible :position, :review_id

  belongs_to :review
end
