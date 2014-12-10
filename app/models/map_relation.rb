class MapRelation < ActiveRecord::Base
  belongs_to :map_layer
  belongs_to :map_placemark
end

# == Schema Information
#
# Table name: map_relations
#
#  map_layer_id     :integer
#  map_placemark_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

