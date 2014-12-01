class MapLayer < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :title, :image

  belongs_to :map_project
  has_many :map_placemarks, dependent: :destroy

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  friendly_id :title, use: :slugged
  def should_generate_new_friendly_id?
    return true if !self.slug?

    false
  end
end

# == Schema Information
#
# Table name: map_layers
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  map_project_id     :integer
#  image_url          :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

