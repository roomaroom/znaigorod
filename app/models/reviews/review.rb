class Review < ActiveRecord::Base
  extend Enumerize
  extend FriendlyId

  include DraftPublishedStates

  attr_accessible :content, :title, :tag, :categories

  belongs_to :account

  has_many :gallery_images, :as => :attachable, :dependent => :destroy

  serialize :categories, Array

  scope :draft,     -> { where :state => :draft }
  scope :published, -> { where :state => :published }

  validates_presence_of :title, :tag, :categories

  enumerize :categories,
    :in => [:auto, :sport, :entertainment, :humor, :family, :culture, :accidents, :animals, :informative, :creation, :cafe, :other],
    :multiple => true,
    :predicates => true

  friendly_id :title, :use => :slugged

  normalize_attribute :categories, :with => :blank_array

  searchable do
    string :state
    string(:category, :multiple => true) { categories.map(&:value) }

    text :content, :more_like_this => true
    text :title,   :more_like_this => true,  :stored => true

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

  def tags
    tag.split(',').map(&:squish).map(&:mb_chars).map(&:downcase)
  end

  def ready_for_publication?
    true
  end

  private

  def self.prefix
    'review_'
  end
end
