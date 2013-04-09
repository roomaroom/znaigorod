class VirtualTour < ActiveRecord::Base
  attr_accessible :link, :attachment

  belongs_to :tourable, :polymorphic => true

  has_one :image, :as => :attacheable, :class_name => 'PaperclipAttachment', :conditions => { :attachment_type => :image }, :dependent => :destroy

  accepts_nested_attributes_for :image, :allow_destroy => true

  validates_presence_of :link

  normalize_attribute :link

  delegate :attachment, :attachment_url, :attachment_url?, :attachment=, :to => :image, :allow_nil => true

  def image
    super || build_image
  end
end
