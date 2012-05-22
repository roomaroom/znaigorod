class Affiche < ActiveRecord::Base
  attr_accessible :description, :poster_url, :showings_attributes, :tag, :title

  validates_presence_of :description, :poster_url, :title

  has_many :showings, :dependent => :destroy

  accepts_nested_attributes_for :showings, :allow_destroy => true

  def starts_on
    showings.first.try(:starts_at).try(:to_date)
  end

  def ends_on
    showings.last.try(:starts_at).try(:to_date)
  end

  def showings_grouped_by_day
    showings.group_by(&:starts_on)
  end
end

# == Schema Information
#
# Table name: affiches
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  description    :text
#  original_title :string(255)
#  poster_url     :string(255)
#  trailer_code   :text
#  type           :string(255)
#  tag            :text
#

