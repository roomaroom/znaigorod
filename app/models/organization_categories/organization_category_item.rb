class OrganizationCategoryItem < ActiveRecord::Base
  belongs_to :organization_category
  belongs_to :organization

  validates :organization_category_id, uniqueness: { :scope => :organization_id }
end

# == Schema Information
#
# Table name: organization_category_items
#
#  id                       :integer          not null, primary key
#  organization_category_id :integer
#  organization_id          :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

