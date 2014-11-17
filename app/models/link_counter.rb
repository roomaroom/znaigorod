class LinkCounter < ActiveRecord::Base
  attr_accessible :name, :type

  extend Enumerize
  enumerize :link_type, :in => [:auto, :cafe, :entertainment, :beauty, :technique, :wear, :birthday, :travel, :home, :children, :other, :students, :photo]
end

# == Schema Information
#
# Table name: link_counters
#
#  id         :integer          not null, primary key
#  link_type  :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

