class Room < ActiveRecord::Base
  include HasVirtualTour

  belongs_to :context, :polymorphic => true

  attr_accessible :capacity, :context_id, :context_type, :description, :feature, :rooms_count, :title, :prices_attributes

  has_many :prices, :as => :context, :class_name => 'DailyPrice', :dependent => :destroy
  has_many :gallery_images, :as => :attachable,  :dependent => :destroy

  accepts_nested_attributes_for :prices, :allow_destroy => true

  validates_presence_of :capacity, :feature

  include PresentsAsCheckboxes

  presents_as_checkboxes :feature

  searchable do
    string :categories, :multiple => true
    string :context_id
    string :context_type
  end

  private

  def categories
    context.categories.map(&:mb_chars).map(&:downcase).map(&:to_s)
  end
end
