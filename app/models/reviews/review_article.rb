class ReviewArticle < Review
  include CropedPoster

  alias_attribute :file_url, :poster_image_url

  before_save :set_poster

  validates :content, :presence => true

  has_attached_file :poster_image, :storage => :elvfs, :elvfs_url => Settings['storage.url'], :default_url => 'public/post_poster_stub.jpg'

  has_croped_poster min_width: 353, min_height: 199

  private

  def set_poster
    self.poster_image = Posts::ContentParser.new(content).poster
  end
end
