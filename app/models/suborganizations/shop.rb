class Shop < ActiveRecord::Base
  include HasVirtualTour
  include HasServices
  include SmsClaims

  attr_accessible :category, :feature, :offer, :payment, :title, :description

  belongs_to :organization

  delegate :address, :phone, :schedules, :halls,
           :site?, :site, :email?, :email, :afisha,
           :latitude, :longitude, :nearest_afisha, :to => :organization

  delegate :title, :description, :description?, to: :organization, prefix: true

  validates_presence_of :organization_id

  has_many :gallery_images, :as => :attachable, :dependent => :destroy

  include PresentsAsCheckboxes

  presents_as_checkboxes :category,
    :validates_presence => true,
    :message => I18n.t('activerecord.errors.messages.at_least_one_value_should_be_checked')

  presents_as_checkboxes :feature
  presents_as_checkboxes :offer

  include SearchWithFacets

  search_with_facets :category, :payment, :feature, :offer, :stuff

  alias_method :sunspot_index, :index
end

# == Schema Information
#
# Table name: shops
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  category        :text
#  feature         :text
#  offer           :text
#  payment         :string(255)
#  title           :string(255)
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

