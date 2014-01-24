# encoding: utf-8

class Work < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :agree, :author_info, :image_url, :title, :description, :image
  attr_accessor :agree

  belongs_to :account
  belongs_to :contest

  has_many :votes, :as => :voteable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  validates_presence_of :image_url, :unless => :image?
  #validates :image, :presence => true, :unless => :image_url

  before_validation :check_contest_actuality
  after_validation :check_agreement_accepted

  friendly_id :title, use: :slugged

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :image,
    :presence => true,
    :content_type => {
      :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
      :message => 'Изображение должно быть в формате jpeg, jpg или png' }, :if => :image_url?

  validates :image, :dimensions => { :width_min => 300, :height_min => 300 }, :if => :image?

  scope :ordered, order('created_at desc')
  scope :ordered_by_likes, order('vk_likes desc')

  def vfs_path
    "/znaigorod/contests/#{contest.id}"
  end

  def to_feed_title
    if self.title.empty?
      return self.slug
    end
    self.title
  end

  private

  def check_contest_actuality
    errors[:base] << 'Contest is not actual' unless contest.actual?

    true
  end

  def check_agreement_accepted
    errors[:agree] << 'Необходимо принять пользовательское соглашение' unless agree == '1'

    true
  end
end

# == Schema Information
#
# Table name: works
#
#  id          :integer          not null, primary key
#  image_url   :text
#  author_info :string(255)
#  contest_id  :integer
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
#  vk_likes    :integer
#

