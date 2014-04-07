class Banner < ActiveRecord::Base
  attr_accessible :image, :title, :url, :width, :height

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_presence_of :title, :url, :image, :width, :height

  searchable do
    text :title
    text :url
    time :updated_at
  end
end
