class ReviewVideo < Review
  attr_accessible :video_url

  validates :video_url, :presence => true
  validates :content, :length => { :maximum => 140 }

  def content_for_show
    @content_for_show ||= AutoHtmlRenderer.new(video_url).render_show
  end

  def content_for_index
    @content_for_index ||= AutoHtmlRenderer.new(video_url).render_index
  end
end
