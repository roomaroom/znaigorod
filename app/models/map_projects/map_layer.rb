class MapLayer < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :title, :image, :icon_image

  validates_presence_of :title, :image, :icon_image

  belongs_to :map_project
  has_many :map_relations, :dependent => :destroy
  has_many :map_placemarks, :through => :map_relations, dependent: :destroy

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']
  has_attached_file :icon_image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

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
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  map_project_id          :integer
#  slug                    :string(255)
#  image_url               :string(255)
#  image_file_name         :string(255)
#  image_content_type      :string(255)
#  image_file_size         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  icon_image_url          :string(255)
#  icon_image_file_name    :string(255)
#  icon_image_content_type :string(255)
#  icon_image_file_size    :string(255)
#

