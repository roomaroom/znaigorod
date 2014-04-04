class Room < ActiveRecord::Base
  belongs_to :context, :polymorphic => true

  attr_accessible :capacity, :context_id, :context_type, :description, :feature, :rooms_count, :title, :prices_attributes

  has_many :prices, :as => :context, :class_name => 'DailyPrice', :dependent => :destroy

  accepts_nested_attributes_for :prices, :allow_destroy => true

  include PresentsAsCheckboxes

  presents_as_checkboxes :feature
end
