class Organization < ActiveRecord::Base
  attr_accessible :address_attributes,
                  :category,
                  :description,
                  :email,
                  :feature,
                  :offer,
                  :payment,
                  :phone,
                  :schedules_attributes,
                  :site,
                  :title

  has_many :schedules, :dependent => :destroy
  has_many :halls, :dependent => :destroy

  has_one :address, :dependent => :destroy

  validates_presence_of :title

  accepts_nested_attributes_for :address, :reject_if => :all_blank
  accepts_nested_attributes_for :schedules, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :halls, :allow_destroy => true, :reject_if => :all_blank

  def self.facets
    %w[category payment cuisine feature offer]
  end

  def self.facet_fields
    facets.inject({}) { |h,v| h[v] = 1; h }
  end

  def self.ru_fields
    { title: 2, address: 1, description: 0.5 }.merge(facet_fields)
  end

  def self.ngram_fields
    { site: 0.5, email: 0.5 }.merge(ru_fields)
  end

  searchable do |s|
    s.integer :capacity, :multiple => true do
      halls.pluck(:seating_capacity)
    end

    s.text    :site
    s.text    :email

    ru_fields.each do |field, boost|
      s.text field,         boost: boost

      s.text "#{field}_ru", boost: boost * 0.9 do
        self.send(field)
      end
    end

    ngram_fields.each do |field, boost|
      s.text "#{field}_ngram", boost: boost * 0.5 do
        self.send(field)
      end
    end

    facets.each do |facet|
      s.string facet, :multiple => true do self.send(facet).to_s.split(',').map(&:squish) end
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
#  id          :integer         not null, primary key
#  title       :text
#  category    :text
#  payment     :text
#  cuisine     :text
#  feature     :text
#  site        :text
#  email       :text
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  phone       :text
#  offer       :text
#  type        :string(255)
#

