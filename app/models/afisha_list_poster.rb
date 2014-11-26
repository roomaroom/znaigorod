class AfishaListPoster < ActiveRecord::Base
  attr_accessible :position, :expires_at, :afisha_id

  belongs_to :afisha

  scope :actual, -> { where 'expires_at > ?', Time.zone.now }
end
