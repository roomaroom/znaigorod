Fabricator(:service) do
  category "MyText"
  feature "MyText"
  age "MyText"
  tag "MyText"
  context_type "MyString"
  context_id 1
end

# == Schema Information
#
# Table name: services
#
#  id           :integer          not null, primary key
#  title        :text
#  feature      :text
#  age          :text
#  tag          :text
#  context_type :string(255)
#  context_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

