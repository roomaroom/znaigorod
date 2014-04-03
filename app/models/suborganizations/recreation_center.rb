class RecreationCenter < ActiveRecord::Base
  include HasVirtualTour
  include HasServices

  attr_accessible :category, :description, :title, :offer, :feature

  belongs_to :organization

  delegate :address, :phone, :latitude, :longitude, :to => :organization
  delegate :title, :to => :organization, :prefix => true

  # OPTIMIZE: <--- similar code
  attr_accessor :vfs_path
  attr_accessible :vfs_path

  def vfs_path
    "#{organization.vfs_path}/#{self.class.name.underscore}"
  end

  has_many :gallery_images, :as => :attachable, :dependent => :destroy
  # similar code --->

  has_many :rooms, :as => :context, :dependent => :destroy

  include PresentsAsCheckboxes

  presents_as_checkboxes :category, :default_value => Values.instance.hotel.categories
  presents_as_checkboxes :feature
  presents_as_checkboxes :offer

  include SearchWithFacets

  search_with_facets :category, :feature, :offer

  alias_method :sunspot_index, :index
  include SmsClaims
end
