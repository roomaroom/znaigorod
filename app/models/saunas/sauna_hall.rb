class SaunaHall < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :title, :tour_link, :vfs_path, :description, :sauna_hall_schedules_attributes,
    :sauna_hall_bath_attributes, :sauna_hall_capacity_attributes, :sauna_hall_entertainment_attributes,
    :sauna_hall_interior_attributes, :sauna_hall_pool_attributes

  belongs_to :sauna

  has_many :images, :as => :imageable,  :dependent => :destroy
  has_many :sauna_hall_schedules,       :dependent => :destroy

  has_one :sauna_hall_bath, :dependent => :destroy
  has_one :sauna_hall_capacity, :dependent => :destroy
  has_one :sauna_hall_entertainment, :dependent => :destroy
  has_one :sauna_hall_interior, :dependent => :destroy
  has_one :sauna_hall_pool, :dependent => :destroy

  accepts_nested_attributes_for :sauna_hall_bath
  accepts_nested_attributes_for :sauna_hall_capacity
  accepts_nested_attributes_for :sauna_hall_entertainment
  accepts_nested_attributes_for :sauna_hall_interior
  accepts_nested_attributes_for :sauna_hall_pool
  accepts_nested_attributes_for :sauna_hall_schedules, :allow_destroy => true, :reject_if => :all_blank
end

# == Schema Information
#
# Table name: sauna_halls
#
#  id          :integer          not null, primary key
#  sauna_id    :integer
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tour_link   :string(255)
#  vfs_path    :text
#  description :text
#

