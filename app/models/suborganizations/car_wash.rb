class CarWash < ActiveRecord::Base
  attr_accessible :category, :description, :title

  belongs_to :organization
end
