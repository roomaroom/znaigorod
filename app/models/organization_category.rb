class OrganizationCategory < ActiveRecord::Base
  attr_accessible :title

  validates :title, presence: true

  has_ancestry
end
