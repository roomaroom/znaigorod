# encoding: utf-8

class Work < ActiveRecord::Base
  extend FriendlyId
  include MakePageVisit

  attr_accessor :agree
  attr_accessible :agree, :author_info, :image_url, :title, :description, :image, :account_id, :sms_counter

  belongs_to :account
  belongs_to :context, :polymorphic => true

  has_many :votes,                  :as => :voteable, :dependent => :destroy
  has_many :page_visits,            :as => :page_visitable, :dependent => :destroy
  has_many :comments,               :as => :commentable, :dependent => :destroy
  has_many :sms_votes,              :dependent => :destroy

  before_validation :check_account_work_uniquness, :on => :create
  before_validation :check_contest_actuality, :on => :create
  after_validation :check_agreement_accepted

  friendly_id :title, use: :slugged

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  scope :ordered_by_id,          order('created_at desc')
  scope :ordered_by_sms_counter, order('sms_counter desc')
  scope :ordered_by_likes,       order('vk_likes desc')
  scope :ordered_by_rating,      order('rating desc')

  def should_generate_new_friendly_id?
    return true if !self.slug?

    false
  end

  def vfs_path
    "/znaigorod/#{context_type.downcase.pluralize}/#{context_id}"
  end

  def likes_count
    votes.liked.size
  end

  def to_feed_title
    return self.slug.to_s if self.title.blank?
    self.title
  end

  def update_rating
    update_attribute :rating, sms_counter and return if context.has_attribute?(:vote_type) && context.vote_type == "sms"

    update_attribute :rating, 1 * votes.liked.count + 0.01 * page_visits.count
  end

  private

  def check_contest_actuality
    return true if context.is_a?(Photogallery)
    errors[:base] << 'Contest is not actual' unless context.actual?

    true
  end

  def check_agreement_accepted
    errors[:agree] << 'Необходимо принять пользовательское соглашение' unless agree == '1'

    true
  end

  def check_account_work_uniquness
    return true if context.is_a?(Photogallery)
    errors[:base] << 'Можно добавить только одну работу для конкурса' if context.accounts.include?(account)

    true
  end
end

# == Schema Information
#
# Table name: works
#
#  id                 :integer          not null, primary key
#  image_url          :text
#  author_info        :string(255)
#  context_id         :integer
#  title              :string(255)
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  slug               :string(255)
#  vk_likes           :integer
#  account_id         :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  context_type       :string(255)
#  rating             :float
#  video_url          :string(255)
#  code               :integer
#  type               :string(255)
#  video_content      :text
#  sms_counter        :integer          default(0)
#

