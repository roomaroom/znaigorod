class ReviewArticle < Review
  validates :content, :presence => true

  private

  def set_poster
    self.poster_image = Posts::ContentParser.new(content).poster
  end
end
