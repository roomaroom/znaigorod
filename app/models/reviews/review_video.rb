class ReviewVideo < Review
  attr_accessible :video_url, :reset_poster

  attr_accessor :reset_poster

  before_save :reset_poster_url, :if => :reset_poster?

  validates :video_url, :presence => true
  validates :content, :length => { :maximum => 140 }

  def content_parser
    @content_parser ||= Reviews::Content::Videos.new(video_url)
  end

  private

  def set_poster
    self.poster_image = Reviews::Content::Parser.new(video_url).poster if reset_poster?
  end

  def reset_poster?
    reset_poster == 'true'
  end

  def reset_poster_url
    self.poster_url = nil
  end
end
