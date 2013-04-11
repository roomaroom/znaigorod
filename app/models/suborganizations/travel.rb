class Travel < ActiveRecord::Base
  include HasVirtualTour

  attr_accessible :category, :description, :title, :offer, :feature

  belongs_to :organization

  delegate :address, :phone, :latitude, :longitude, :to => :organization

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

  presents_as_checkboxes :category, :default_value => Values.instance.travel.categories
  presents_as_checkboxes :feature
  presents_as_checkboxes :offer

  include SearchWithFacets

  search_with_facets :category, :feature, :offer
end
