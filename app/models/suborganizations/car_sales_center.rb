class CarSalesCenter < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :category, :feature, :offer, :title
end
