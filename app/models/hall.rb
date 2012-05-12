class Hall < ActiveRecord::Base
  belongs_to :organization
end
# == Schema Information
#
# Table name: halls
#
#  id               :integer         not null, primary key
#  title            :string(255)
#  seating_capacity :integer
#  organization_id  :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

