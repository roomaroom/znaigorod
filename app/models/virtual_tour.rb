class VirtualTour < ActiveRecord::Base
  attr_accessible :link, :image_attributes

  belongs_to :tourable, :polymorphic => true

  has_one :image, :as => :attacheable, :class_name => 'PaperclipAttachment', :conditions => { :attachment_type => :image }

  accepts_nested_attributes_for :image, :allow_destroy => true

  validates_presence_of :link

  normalize_attribute :link
end
