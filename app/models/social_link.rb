class SocialLink < ActiveRecord::Base
  attr_accessible :title, :url

  belongs_to :organization
end
