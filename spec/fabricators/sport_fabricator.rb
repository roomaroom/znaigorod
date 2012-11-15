Fabricator(:sport) do
  category "MyText"
  feature "MyText"
  age "MyString"
end

# == Schema Information
#
# Table name: sports
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#

