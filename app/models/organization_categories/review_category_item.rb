class ReviewCategoryItem < ActiveRecord::Base
  belongs_to :organization_category
  belongs_to :review

  validates :organization_category_id, uniqueness: { :scope => :review_id }
end

# == Schema Information
#
# Table name: review_category_items
#
#  id                       :integer          not null, primary key
#  organization_category_id :integer
#  review_id                :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

