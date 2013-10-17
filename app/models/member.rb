class Member < ActiveRecord::Base
  belongs_to :memberable
  belongs_to :account

  validates_uniqueness_of :account_id, :scope => [:memberable_id, :memberable_type]
end

# == Schema Information
#
# Table name: members
#
#  id              :integer          not null, primary key
#  memberable_id   :integer
#  memberable_type :string(255)
#  account_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

