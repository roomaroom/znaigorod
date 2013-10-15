class Member < ActiveRecord::Base
  belongs_to :memberable
  belongs_to :account

  validates_uniqueness_of :account_id, :scope => [:memberable_id, :memberable_type]
end
