class MapProject < ActiveRecord::Base
  attr_accessible :title

  has_many :map_layers, dependent: :destroy
end

# == Schema Information
#
# Table name: map_projects
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

