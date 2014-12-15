class TeaserItem < ActiveRecord::Base
  attr_accessible :text, :image, :url

  belongs_to :teaser

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']
end

# == Schema Information
#
# Table name: teaser_items
#
#  id                 :integer          not null, primary key
#  text               :text
#  teaser_id          :integer
#  image_url          :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

