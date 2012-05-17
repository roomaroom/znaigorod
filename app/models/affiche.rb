class Affiche < ActiveRecord::Base
  attr_accessible :description, :original_title, :poster_url, :showings_attributes, :title, :trailer_code

  validates_presence_of :ends_on, :poster_url, :starts_on, :title

  has_many :showings

  accepts_nested_attributes_for :showings, :allow_destroy => true

  def starts_on
    showings.first.try :starts_at
  end

  def ends_on
    showings.last.try :starts_at
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
#

