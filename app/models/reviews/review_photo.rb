class ReviewPhoto < Review
  def ready_for_publication?
    gallery_images.count > 5
  end
end
