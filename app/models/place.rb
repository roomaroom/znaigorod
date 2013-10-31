class Place < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :organization_id

  belongs_to :organization
  belongs_to :placeable, :polymorphic => true

  validates_presence_of :address, :latitude, :longitude, :unless => :organization_id?
end
