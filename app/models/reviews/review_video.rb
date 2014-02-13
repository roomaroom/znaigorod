class ReviewVideo < Review
  attr_accessible :video_url

  validates :video_url, :presence => true
  validates :content, :length => { :maximum => 140 }

  private

  def set_poster
    self.poster_image = Posts::ContentParser.new(video_url).poster
  end
end
