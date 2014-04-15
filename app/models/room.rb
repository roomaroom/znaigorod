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
    string :categories,       :multiple => true
    string :context_features, :multiple => true
    string :context_id
    string :context_type
    string :room_features,    :multiple => true
  end

  private

  def categories
    context.categories.map(&:mb_chars).map(&:downcase).map(&:to_s)
  end

  def room_featutes
    features.map(&:mb_chars).map(&:downcase).map(&:to_s)
  end

  def context_features
    context.features.map(&:mb_chars).map(&:downcase).map(&:to_s)
  end
end
