class Review < ActiveRecord::Base
  extend Enumerize
  extend FriendlyId

  include CropedPoster
  include DraftPublishedStates
  include MakePageVisit

  attr_accessor :link_with_title, :link_with_value, :link_with_reset

  alias_attribute :file_url,       :poster_image_url
  alias_attribute :description,    :content
  alias_attribute :description_ru, :content

  before_save :handle_link_with_value
  before_save :set_poster

  attr_accessible :content, :title, :tag, :categories,
    :link_with_title, :link_with_value, :link_with_reset

  belongs_to :account
  belongs_to :afisha
  belongs_to :organization

  has_many :comments,       :as => :commentable,    :dependent => :destroy
  has_many :gallery_images, :as => :attachable,     :dependent => :destroy
  has_many :page_visits,    :as => :page_visitable, :dependent => :destroy
  has_many :votes,          :as => :voteable,       :dependent => :destroy

  serialize :categories, Array

  scope :draft,     -> { where :state => :draft }
  scope :published, -> { where :state => :published }

  validates_presence_of :title, :tag, :categories

  enumerize :categories,
    :in => [:auto, :sport, :entertainment, :humor, :family, :culture, :accidents, :animals, :informative, :creation, :cafe, :other],
    :multiple => true,
    :predicates => true

  friendly_id :title, :use => :slugged

  has_croped_poster min_width: 353, min_height: 199, :default_url => 'public/post_poster_stub.jpg'

  normalize_attribute :categories, :with => :blank_array

  searchable do
    string :state
    string(:category, :multiple => true) { categories.map(&:value) }
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

  private

  def self.prefix
    'review_'
  end

  def set_poster
    true
  end

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
