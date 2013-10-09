class Coupon < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :description, :ends_on, :kind, :poster_url, :rating, :slug, :starts_on, :title
end
