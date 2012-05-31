class Organization < ActiveRecord::Base
  attr_accessible :address_attributes,
                  :organization_categories,
                  :description,
                  :email,
                  :feature,
                  :halls_attributes,
                  :images_attributes,
                  :offer,
                  :payment,
                  :phone,
                  :schedules_attributes,
                  :site,
                  :title,
                  :vfs_path

  has_many :halls, :dependent => :destroy
  has_many :images, :dependent => :destroy
  has_many :schedules, :dependent => :destroy

  has_one :address, :dependent => :destroy

  validates_presence_of :title

  accepts_nested_attributes_for :address, :reject_if => :all_blank
  accepts_nested_attributes_for :halls, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :schedules, :allow_destroy => true, :reject_if => :all_blank

  def self.facets
    %w[organization_categories payment cuisine feature offer]
  end

  def self.facet_fields
    facets.inject({}) { |h,v| h[v] = 1; h }
  end

  def self.ru_fields
    { title: 2, address: 1, description: 0.5 }.merge(facet_fields)
  end

  searchable do |s|
    s.integer(:capacity, :multiple => true) { halls.pluck(:seating_capacity) }
    s.string(:kind) { 'organization' }
    s.text :address
    s.text :description, :boost => 0.5
    s.text :email, :boost => 0.5
    s.text :site, :boost => 0.5
    s.text :title, :boost => 2
    s.text(:kind) { self.class.model_name.human }

    facets.each do |facet|
      s.text facet
      s.string(facet, :multiple => true) { self.send(facet).to_s.split(',').map(&:squish) }
    end
  end

  def to_s
    title
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id                      :integer         not null, primary key
#  title                   :text
#  organization_categories :text
#  payment                 :text
#  cuisine                 :text
#  feature                 :text
#  site                    :text
#  email                   :text
#  description             :text
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  phone                   :text
#  offer                   :text
#  type                    :string(255)
#  vfs_path                :string(255)
#

