class SectionPage < ActiveRecord::Base
  attr_accessible :title, :content, :poster

  belongs_to :section
end
