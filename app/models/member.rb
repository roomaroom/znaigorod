class Member < ActiveRecord::Base
  belongs_to :memberable
  belongs_to :account
end
