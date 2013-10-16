# encoding: utf-8

class Discount < ActiveRecord::Base
  include CropedPoster
  include MakePageVisit

  attr_accessible :title, :description, :ends_at, :kind, :starts_at,
                  :discount, :organization_title, :organization_id

  attr_accessor :organization_title

  belongs_to :account
  belongs_to :organization

  has_many :comments,    :dependent => :destroy, :as => :commentable
  has_many :members,     :dependent => :destroy, :as => :memberable
  has_many :page_visits, :dependent => :destroy, :as => :page_visitable
  has_many :votes,       :dependent => :destroy, :as => :voteable

  has_many :accounts, :through => :members

  validates_presence_of :title, :description, :kind, :starts_at, :ends_at, :discount, :kind

  extend Enumerize
  serialize :kind, Array
  enumerize :kind, :in => [:beauty, :entertainment, :sport], :multiple => true, :predicates => true
  normalize_attribute :kind, with: :blank_array

  extend FriendlyId
  friendly_id :title, use: :slugged

  searchable do
    date :created_at
    time :ends_at

    #float :rating

    string(:kind, :multiple => true) { kind.map(&:value) }
    string(:type) { self.class.name.underscore }

    text :title, :stored => true, :more_like_this => true
  end

  def likes_count
    self.votes.liked.count
  end

  # === STUBS ===
  def copies
    []
  end

  def emails
    []
  end
end

# == Schema Information
#
# Table name: discounts
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  description               :text
#  poster_url                :text
#  type                      :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  poster_image_url          :text
#  starts_at                 :datetime
#  ends_at                   :datetime
#  slug                      :string(255)
#  total_rating              :float
#  kind                      :text
#  number                    :integer
#  origin_price              :integer
#  price                     :integer
#  discounted_price          :integer
#  discount                  :integer
#  payment_system            :string(255)
#  state                     :string(255)
#  origin_url                :text
#  organization_id           :integer
#  account_id                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

