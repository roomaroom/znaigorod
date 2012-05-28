class Image < ActiveRecord::Base
  belongs_to :organization

  attr_accessible :description, :url
end

# == Schema Information
#
# Table name: images
#
#  id              :integer         not null, primary key
#  url             :text
#  organization_id :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  description     :text
#

