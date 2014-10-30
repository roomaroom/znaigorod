class SectionPage < ActiveRecord::Base
  include CropedPoster

  attr_accessible :title, :content, :poster, :generate_poster

  attr_accessor  :generate_poster

  has_many :gallery_images,        :as => :attachable,     :dependent => :destroy
  belongs_to :section

  before_save :store_cached_content_for_show, :store_cached_content_for_index, :set_poster

  has_attached_file :poster_image, storage: :elvfs, elvfs_url: Settings['storage.url']

  def store_cached_content_for_index
    self.cached_content_for_index = AutoHtmlRenderer.new(content).render_index
  end

  def store_cached_content_for_show
    self.cached_content_for_show = AutoHtmlRenderer.new(content).render_show
  end

  def set_poster
    self.poster_image = Reviews::Content::Parser.new(content).poster
  end
end
