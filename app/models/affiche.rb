class Affiche < ActiveRecord::Base
  attr_accessible :description, :original_title, :title, :trailer_code

  validates_presence_of :title
end
