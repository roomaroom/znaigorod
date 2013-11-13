class Place < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :organization_id

  belongs_to :organization
  belongs_to :placeable, :polymorphic => true

  validates_presence_of :address, :latitude, :longitude, :unless => :organization_id?

  delegate :sunspot_index, :to => :placeable, :prefix => true
  after_save    :placeable_sunspot_index
  after_destroy :placeable_sunspot_index
end

# == Schema Information
#
# Table name: places
#
#  id              :integer          not null, primary key
#  placeable_id    :integer
#  placeable_type  :string(255)
#  address         :string(255)
#  latitude        :string(255)
#  longitude       :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string(255)
#

