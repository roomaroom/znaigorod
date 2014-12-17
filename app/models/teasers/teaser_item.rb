class TeaserItem < ActiveRecord::Base
  attr_accessible :text, :image, :url

  belongs_to :teaser

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  scope :order_by_id, order('id')
end

# == Schema Information
#
# Table name: teaser_items
#
#  id                 :integer          not null, primary key
#  teaser_id          :integer
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :string(255)
#  image_url          :string(255)
#  url                :string(255)
#  text               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

