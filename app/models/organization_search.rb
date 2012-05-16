class OrganizationSearch < Search
  attr_accessible :keywords

  column :keywords,       :text
end

# == Schema Information
#
# Table name: searches
#
#  keywords :text
#

