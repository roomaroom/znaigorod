class Review < ActiveRecord::Base
  extend Enumerize
  extend FriendlyId

  include Album::Downloader
  include CropedPoster
  include DraftPublishedStates
  include MakePageVisit
  include VkUpload

  attr_accessor :link_with_title, :link_with_value, :link_with_reset

  alias_attribute :file_url,       :poster_image_url
  alias_attribute :description,    :content
  alias_attribute :description_ru, :content

  before_save :handle_link_with_value
  before_save :set_poster

  before_save :store_cached_content_for_index
  before_save :store_cached_content_for_show

  attr_accessible :content, :title, :tag, :categories,
    :link_with_title, :link_with_value, :link_with_reset,
    :allow_external_links,
    :only_tomsk

  belongs_to :account
  belongs_to :afisha
  belongs_to :contest
  belongs_to :organization

  has_many :all_images,            :as => :attachable, :class_name => 'Attachment', :conditions => { :type => %w[GalleryImage GallerySocialImage] }
  has_many :comments,              :as => :commentable,    :dependent => :destroy
  has_many :gallery_images,        :as => :attachable,     :dependent => :destroy
  has_many :gallery_social_images, :as => :attachable,     :dependent => :destroy
  has_many :messages,              :as => :messageable,    :dependent => :destroy
  has_many :page_visits,           :as => :page_visitable, :dependent => :destroy
  has_many :votes,                 :as => :voteable,       :dependent => :destroy
  has_many :webanketas,            :as => :context,        :dependent => :destroy

  # Relations
  has_many :relations, :as => :master, :dependent => :destroy
  has_many :afishas,       :through => :relations, :source => :slave, :source_type => Afisha
  has_many :organizations, :through => :relations, :source => :slave, :source_type => Organization
  has_many :reviews,       :through => :relations, :source => :slave, :source_type => Review

  attr_accessible :relations_attributes
  accepts_nested_attributes_for :relations, :reject_if => :all_blank, :allow_destroy => true

  has_many :users,                 :through => :account

  has_one  :feed, :as => :feedable, :dependent => :destroy

  serialize :categories, Array

  scope :by_state,  ->(state) { where :state => state }
  scope :draft,     -> { where :state => :draft }
  scope :published, -> { where :state => :published }

  validates_presence_of :title, :tag, :categories

  default_value_for :allow_external_links, false
  default_value_for :only_tomsk,           false

  enumerize :categories,
    :in => [:auto, :sport, :entertainment, :humor, :family, :eighteen_plus, :culture, :accidents, :animals, :informative, :creation, :cafe, :other, :abiturient],
    :multiple => true,
    :predicates => true

  friendly_id :title, :use => :slugged

  def normalize_friendly_id(string)
    I18n.l(created_at, :format => '%Y-%m') + '/' + super
  end

  has_croped_poster min_width: 353, min_height: 199, :default_url => 'public/post_poster_stub.jpg'

  normalize_attribute :title, :with => [:strip, :squish]
  normalize_attribute :categories, :with => :blank_array

  searchable do
    boolean :only_tomsk

    float :rating

    integer(:commented) { comments.size }

    string :state
    string(:category, :multiple => true) { categories.map(&:value) }
    string(:search_kind) { 'review' }
    string(:type) { useful_type }

    text :content,        :boost => 0.1 * 1.2
    text :description_ru, :boost => 0.1, :more_like_this => true, :stored => true
    text :title,          :boost => 1.0, :more_like_this => true, :stored => true

    time :created_at, :trie => true
  end

  def self.descendant_names
    descendants.map(&:name).map(&:underscore)
  end

  def self.descendant_names_without_prefix
    descendant_names.map { |name| name.gsub prefix, '' }
  end

  def useful_type
    self.class.name.underscore.gsub self.class.prefix, ''
  end

  def should_generate_new_friendly_id?
    return true if !self.slug? && self.published?

    false
  end

  def ready_for_publication?
    true
  end

  def linked?
    !!(afisha_id || organization_id)
  end

  def update_rating
    update_attribute :rating, 0.5 * comments.count + 0.1 * votes.liked.count + 0.01 * page_visits.count
  end

  def has_poster?
    !!(image_url)
  end

  def user
    users.first
  end

  private

  def self.prefix
    'review_'
  end

  def set_poster
    true
  end

  def handle_link_with_value
    if link_with_reset == 'true'
      self.afisha_id = self.organization_id = self.contest_id = nil
      return true
    end

    return true if link_with_value.blank?

    class_name, id = link_with_value.split('_')

    return false unless Reviews::LinkWith.available_types.include?(class_name)

    object = class_name.classify.constantize.find(id)

    self.afisha_id = self.organization_id = self.contest_id = nil

    case object
    when Afisha
      self.afisha = object
      self.organization = object.organizations.first
    when Organization
      self.organization = object
    when Contest
      self.contest = object
    end
  end

  def store_cached_content_for_index
    self.cached_content_for_index = is_a?(ReviewVideo) ?
      AutoHtmlRenderer.new(video_url).render_index + AutoHtmlRenderer.new(content).render_index :
      AutoHtmlRenderer.new(content).render_index
  end

  def store_cached_content_for_show
    self.cached_content_for_show = is_a?(ReviewVideo) ?
      AutoHtmlRenderer.new(video_url).render_show + AutoHtmlRenderer.new(content, allow_external_links: allow_external_links).render_show :
      AutoHtmlRenderer.new(content, allow_external_links: allow_external_links).render_show
  end

  # overrides VkUpload.image_url
  def image_url
    return poster_url if poster_url?
    return poster_image_url if poster_image_url?
    return gallery_images.first.file_url if gallery_images.any?
    return gallery_social_images.first.file_url if gallery_social_images.any?
  end
end
