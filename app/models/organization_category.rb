class OrganizationCategory < ActiveRecord::Base
  alias_attribute :to_s, :title
  attr_accessible :title

  default_scope order('title')

  validates :title, presence: true, uniqueness: { scope: :ancestry }

  has_ancestry
end
