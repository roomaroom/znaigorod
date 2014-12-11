class TeaserItem < ActiveRecord::Base
  attr_accessible :text

  belongs_to :teaser
end
