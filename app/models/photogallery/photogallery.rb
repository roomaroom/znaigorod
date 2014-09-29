class Photogallery < ActiveRecord::Base
  extend FriendlyId
  include MakePageVisit

  attr_accessible :agreement, :description, :og_description, :og_image_content_type, :og_image_file_name, :og_image_file_size,
    :og_image_updated_at, :og_image_url, :slug, :title, :vfs_path, :og_image,
    :available_participation, :page_meta_keywords, :page_meta_description

  friendly_id :title, use: :slugged

  has_attached_file :og_image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :og_image, :content_type => {
    :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате jpeg, jpg или png'
  }

  has_many :works,                 :as => :context, :dependent => :destroy
  has_many :comments,              :as => :commentable,    :dependent => :destroy
  has_many :votes,                 :as => :voteable,       :dependent => :destroy
  has_many :page_visits,           :as => :page_visitable, :dependent => :destroy

  alias_attribute :title_ru,       :title
  alias_attribute :title_translit, :title

  searchable do
    string :title
    text :description
  end

  def self.generate_vfs_path
    "/znaigorod/photogalleries/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end

  def type_without_prefix
    "photo"
  end

  def likes_count
    self.votes.liked.count
  end

  def image_url
    image_url = if self.works.present?
                 works.first.image_url
               else
                 'public/default_image.png'
               end
  end
end

# == Schema Information
#
# Table name: photogalleries
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  slug                    :string(255)
#  description             :text
#  vfs_path                :string(255)
#  og_description          :text
#  og_image_file_name      :string(255)
#  og_image_content_type   :string(255)
#  og_image_file_size      :integer
#  og_image_updated_at     :datetime
#  og_image_url            :text
#  agreement               :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  available_participation :boolean
#  page_meta_description   :text
#  page_meta_keywords      :text
#

