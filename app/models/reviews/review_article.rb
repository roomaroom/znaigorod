class ReviewArticle < Review
  validates :content, :presence => true
end
