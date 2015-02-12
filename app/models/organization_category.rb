class OrganizationCategory < ActiveRecord::Base
  attr_accessible :title

  validates :title, presence: true, uniqueness: { scope: :ancestry }

  has_ancestry
end
