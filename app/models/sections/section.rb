class Section < ActiveRecord::Base
  attr_accessible :title

  has_many :section_pages, :dependent => :destroy
  belongs_to :organization
end

# == Schema Information
#
# Table name: sections
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

