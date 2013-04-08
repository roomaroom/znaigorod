class VirtualTour < ActiveRecord::Base
  belongs_to :tourable, :polymorphic => true
  attr_accessible :link
  validates_presence_of :link
  normalize_attribute :link
end
