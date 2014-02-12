class ReviewVideo < Review
  attr_accessible :video_url

  validates :video_url, :presence => true
  validates :content, :length => { :maximum => 140 }
end
