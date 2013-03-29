class CarWash < ActiveRecord::Base
  attr_accessible :category, :description, :title, :offer, :feature

  belongs_to :organization

  # OPTIMIZE: <--- similar code
  attr_accessor :vfs_path
  attr_accessible :vfs_path
  def vfs_path
    "#{organization.vfs_path}/#{self.class.name.underscore}"
  end
  has_many :images, :as => :imageable, :dependent => :destroy

  def sunspot_index
    index
  end
  # similar code --->

  include PresentsAsCheckboxes

  presents_as_checkboxes :category, :default_value => Values.instance.car_wash.categories
  presents_as_checkboxes :feature
  presents_as_checkboxes :offer

  include SearchWithFacets

  search_with_facets :category, :feature, :offer
end

# == Schema Information
#
# Table name: car_washes
#
#  id              :integer          not null, primary key
#  category        :text
#  organization_id :integer
#  title           :string(255)
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  offer           :text
#  feature         :text
#

