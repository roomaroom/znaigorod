class ReviewPhoto < Review
  validates :tag, :presence => true

  def ready_for_publication?
    all_images.count > 5
  end
end
