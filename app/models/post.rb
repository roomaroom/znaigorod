# encoding: utf-8

class Post < ActiveRecord::Base
  include CropedPoster
  include MakePageVisit
  extend FriendlyId

  attr_accessible :content, :status, :title, :vfs_path, :rating, :tag, :kind, :categories, :afisha_id, :organization_id

  attr_accessible :link_with_title, :link_with_value, :link_with_reset
  attr_accessor :link_with_title, :link_with_value, :link_with_reset

  belongs_to :afisha
  belongs_to :organization

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :gallery_images, :as => :attachable, :dependent => :destroy
  has_many :votes, :as => :voteable, :dependent => :destroy
  has_many :page_visits, :as => :page_visitable, :dependent => :destroy

  alias_attribute :description, :content

  validates_presence_of :content, :title, :kind, :tag, :categories

  before_save :handle_link_with_value

  friendly_id :title, use: :slugged

  extend Enumerize
  serialize :kind, Array
  enumerize :kind, in: [:review, :photoreport], multiple: true, predicates: true

  serialize :categories, Array
  enumerize :categories, in: [:avto, :beaty, :other], multiple: true, predicates: true
  normalize_attribute :categories, :with => :blank_array

  normalize_attribute :kind, with: :blank_array
  normalize_attribute :content, :with => [:strip, :blank]

  default_scope order('id DESC')

  scope :published, -> { where(:status => true) }
  scope :draft,     -> { where(:status => false) }

  searchable do
    text :content,              :more_like_this => true
    text :title,                :more_like_this => true,  :stored => true
    text :tag,                  :more_like_this => true,  :stored => true
    date :created_at
    float :rating,              :trie => true
    string :search_kind
    string(:status) { status? ? 'published' : 'draft' }
    string(:kind, :multiple => true) { kind.map(&:value) }
  end

  def content_for_show
    @content_for_show = AutoHtmlRenderer.new(content).render_show
  end

  def content_for_index
    @content_for_index = AutoHtmlRenderer.new(content).render_index
  end

  def search_kind
    self.class.name.underscore
  end

  def similar_post
    HasSearcher.searcher(:similar_posts).more_like_this(self).limit(6).results
  end

  def tags
    tag.to_s.split(/,\s+/).map(&:mb_chars).map(&:downcase).map(&:squish)
  end

  def images
    gallery_images
  end

  def likes_count
    self.votes.liked.count
  end

  def update_rating
    update_attribute :rating, (0.5*comments.count + 0.1*votes.liked.count + 0.01*page_visits.count)
  end

  def linked?
    !!(afisha_id || organization_id)
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

