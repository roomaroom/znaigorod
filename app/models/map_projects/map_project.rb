class MapProject < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :title
  validates_presence_of :title

  has_many :map_layers, dependent: :destroy

  friendly_id :title, use: :slugged
  def should_generate_new_friendly_id?
    return true if !self.slug?

    false
  end
end

# == Schema Information
#
# Table name: map_projects
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

