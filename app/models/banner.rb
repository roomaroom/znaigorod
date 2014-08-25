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

# == Schema Information
#
# Table name: banners
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  url                :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  image_url          :text
#  width              :integer
#  height             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

