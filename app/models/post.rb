# encoding: utf-8

class Post < ActiveRecord::Base
  extend Enumerize
  extend FriendlyId

  include CropedPoster
  include DraftPublishedStates
  include MakePageVisit

  attr_accessible :content, :title, :vfs_path, :rating, :tag, :kind, :categories, :afisha_id, :organization_id

  attr_accessible :link_with_title, :link_with_value, :link_with_reset
  attr_accessor :link_with_title, :link_with_value, :link_with_reset
  before_save :handle_link_with_value

  attr_accessible :need_poster
  attr_accessor :need_poster
  before_save :set_poster, :if => :need_poster?

  belongs_to :account
  belongs_to :afisha
  belongs_to :organization

  has_many :comments,       :as => :commentable,    :dependent => :destroy
  has_many :gallery_images, :as => :attachable,     :dependent => :destroy
  has_many :messages,       :as => :messageable,    :dependent => :destroy
  has_many :page_visits,    :as => :page_visitable, :dependent => :destroy
  has_many :votes,          :as => :voteable,       :dependent => :destroy

  has_one :feed,   :dependent => :destroy, :as => :feedable

  alias_attribute :description, :content

  validates_presence_of :content, :title, :tag, :categories

  friendly_id :title, use: :slugged
  def should_generate_new_friendly_id?
    return true if !self.slug? && self.published?

    false
  end

  has_attached_file :poster_image, :storage => :elvfs, :elvfs_url => Settings['storage.url'], :default_url => 'public/post_poster_stub.jpg'
  alias_attribute :file_url, :poster_image_url

  #serialize :kind, Array
  #enumerize :kind, in: [:with_gallery, :with_video], multiple: true, predicates: true

  serialize :categories, Array
  enumerize :categories, in: [:avto, :beaty, :other], multiple: true, predicates: true
  normalize_attribute :categories, :with => :blank_array

  normalize_attribute :content, :with => [:strip, :blank]

  default_scope order('id DESC')

  scope :draft,     -> { where :state => :draft }
  scope :published, -> { where :state => :published }

  searchable do
    float :rating

    string :state
    string(:category, :multiple => true) { categories.map(&:value) }
    string(:kind, :multiple => true) { kinds }

    text :content, :more_like_this => true
    text :title,   :more_like_this => true,  :stored => true

    time :created_at, :trie => true
  end

  def content_for_show
    @content_for_show = AutoHtmlRenderer.new(content).render_show
  end

  def content_for_index
    @content_for_index = AutoHtmlRenderer.new(content).render_index
  end

  def tags
    tag.to_s.split(/,\s+/).map(&:mb_chars).map(&:downcase).map(&:squish).map(&:to_s)
  end

  def images
    gallery_images
  end

  def likes_count
    self.votes.liked.count
  end

  def update_rating
    update_attribute :rating, 0.5 * comments.count + 0.1 * votes.liked.count + 0.01 * page_visits.count
  end

  def linked?
    !!(afisha_id || organization_id)
  end

  def ready_for_publication?
    title.present? && content.present? && draft?
  end

  def content_parser
    @content_parser ||= Posts::ContentParser.new(content)
  end

  def video_preview?
    !poster_url? && Posts::ContentParser.new(content).youtube_videos.any?
  end

  private

  def handle_link_with_value
    if link_with_reset == 'true'
      self.afisha_id = self.organization_id = nil
      return true
    end

    return true if link_with_value.blank?

    class_name, id = link_with_value.split('_')

    return false unless %w[afisha organization].include?(class_name)

    object = class_name.classify.constantize.find(id)

    if object.is_a?(Afisha)
      self.afisha = object
      self.organization = object.organizations.first
    else
      self.afisha = nil
      self.organization = object
    end
  end

  def need_poster?
    !(need_poster == 'false')
  end

  def set_poster
    self.poster_image = Posts::ContentParser.new(content).poster
  end

  def kinds
    [].tap do |kinds|
      kinds << :with_gallery if gallery_images.any?
      kinds << :with_video if content_parser.youtube_videos.any?
    end
  end
end

# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  poster_url :text
#  vfs_path   :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :boolean          default(FALSE)
#  rating     :float
#  kind       :text
#  tag        :text
#

