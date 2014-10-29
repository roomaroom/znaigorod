class Section < ActiveRecord::Base
  attr_accessible :title

  has_many :section_pages, :dependent => :destroy
  belongs_to :organization
end
