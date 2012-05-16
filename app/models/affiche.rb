class Affiche < ActiveRecord::Base
  attr_accessible :description, :ends_on, :original_title, :starts_on, :title, :trailer_code

  validates_presence_of :ends_on, :starts_on, :title
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
#  starts_on      :date
#  ends_on        :date
#

