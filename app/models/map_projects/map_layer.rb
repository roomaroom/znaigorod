class MapLayer < ActiveRecord::Base
  attr_accessible :title

  belongs_to :map_project
  has_many :map_placemarks, dependent: :destroy
end

# == Schema Information
#
# Table name: map_layers
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  map_project_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

