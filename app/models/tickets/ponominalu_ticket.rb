class PonominaluTicket < ActiveRecord::Base
  belongs_to :afisha_id
  attr_accessible :count, :ponominalu_id
end
