class SectionPage < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  validates_presence_of :title, :content

  attr_accessible :title, :content, :poster

  has_many :gallery_images,        :as => :attachable,     :dependent => :destroy
  belongs_to :section

  before_save :store_cached_content_for_show,
              :store_cached_content_for_index,
              :set_poster

  has_attached_file :poster_image, storage: :elvfs, elvfs_url: Settings['storage.url']

  def store_cached_content_for_index
    self.cached_content_for_index = AutoHtmlRenderer.new(content).render_index
  end

  def store_cached_content_for_show
    self.cached_content_for_show = AutoHtmlRenderer.new(content, allow_external_links: true).render_show
  end

  def set_poster
    self.poster_image = Reviews::Content::Parser.new(content).poster
  end

  def content_for_show(sanitize = true, options = {})
    if sanitize
      sanitize(cached_content_for_show.try(:html_safe), :tags => %w(ul li h3 p b strong strike span table tr td tbody thead), :attributes => ['id', 'class', 'style']) # tags => allowed tags
    else
      cached_content_for_show.try(:html_safe)
    end
  end
end

# == Schema Information
#
# Table name: section_pages
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  content                   :text
#  cached_content_for_index  :text
#  cached_content_for_show   :text
#  section_id                :integer
#  poster_image_url          :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

