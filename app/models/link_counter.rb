class LinkCounter < ActiveRecord::Base
  attr_accessible :name, :type
end

# == Schema Information
#
# Table name: link_counters
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

