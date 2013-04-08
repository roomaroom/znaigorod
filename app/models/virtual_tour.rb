class VirtualTour < ActiveRecord::Base
  belongs_to :tourable, :polymorphic => true
  attr_accessible :link
end
