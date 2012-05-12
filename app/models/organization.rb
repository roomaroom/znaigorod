class Organization < ActiveRecord::Base
  has_many :schedules, :dependent => :destroy
  has_many :halls, :dependent => :destroy

  has_one :address, :dependent => :destroy

  validates_presence_of :title

  accepts_nested_attributes_for :address, :reject_if => :all_blank
  accepts_nested_attributes_for :schedules, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :halls, :allow_destroy => true, :reject_if => :all_blank

  FACETS = %w[category payment cuisine feature offer]

  FACET_FILEDS = FACETS.inject({}) { |h,v| h[v] = 1; h }
  RU_FILEDS = { title: 2, address: 1, description: 0.5 }.merge(FACET_FILEDS)
  NGRAM_FIEDS = { site: 0.5, email: 0.5 }.merge(RU_FILEDS)

  searchable do
    integer :capacity, :multiple => true do
      halls.pluck(:seating_capacity)
    end

    text    :site
    text    :email

    RU_FILEDS.each do |field, boost|
      text field,         boost: boost

      text "#{field}_ru", boost: boost * 0.9 do
        self.send(field)
      end
    end

    NGRAM_FIEDS.each do |field, boost|
      text "#{field}_ngram", boost: boost * 0.5 do
        self.send(field)
      end
    end

    FACETS.each do |facet|
      string facet, :multiple => true do self.send(facet).to_s.split(',').map(&:squish) end
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
#

