class SaunaHallInterior < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :floors, :lounges, :pit, :pylon, :barbecue

  belongs_to :sauna_hall
end

# == Schema Information
#
# Table name: sauna_hall_interiors
#
#  id            :integer          not null, primary key
#  sauna_hall_id :integer
#  floors        :integer
#  lounges       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  pit           :boolean
#  pylon         :boolean
#  barbecue      :boolean
#

