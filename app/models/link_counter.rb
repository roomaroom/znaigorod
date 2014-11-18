class LinkCounter < ActiveRecord::Base
  attr_accessible :name, :link_type, :link, :count

  extend Enumerize
  enumerize :link_type, :in => [:external, :banner, :right], scope: true
end

# == Schema Information
#
# Table name: link_counters
#
#  id         :integer          not null, primary key
#  link_type  :string(255)
#  name       :string(255)
#  link       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

