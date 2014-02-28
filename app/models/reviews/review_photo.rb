class ReviewPhoto < Review
  def ready_for_publication?
    all_images.count > 5
  end
end
