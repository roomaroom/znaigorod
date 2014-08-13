class Photogallery < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :agreement, :description, :og_description, :og_image_content_type, :og_image_file_name, :og_image_file_size, :og_image_updated_at, :og_image_url, :slug, :title, :vfs_path, :og_image, :available_participation

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

  def self.generate_vfs_path
    "/znaigorod/photogalleries/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end

end
