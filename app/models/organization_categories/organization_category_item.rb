class OrganizationCategoryItem < ActiveRecord::Base
  belongs_to :organization_category
  belongs_to :organization

  validates :organization_category_id, uniqueness: { :scope => :organization_id }
end
