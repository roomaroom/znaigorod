class ReviewArticle < Review
  attr_accessible :generate_poster

  attr_accessor :generate_poster

  validates :content, :presence => true

  private

  def generate_poster?
    generate_poster == 'true'
  end

  def set_poster
    self.poster_image = Reviews::Content::Parser.new(content).poster if generate_poster? && !poster_url?
  end
end
