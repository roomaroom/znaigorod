class Question < Review
  after_create :to_published!

  def normalize_friendly_id(string)
    old_normalize_friendly_id(string)
  end
end
