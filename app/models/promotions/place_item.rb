class PlaceItem < ActiveRecord::Base
  attr_accessible :url

  belongs_to :promotion_place

  validates :url, :presence => true

  normalize_attribute(:url) { |value| value.gsub(/^\//, '') }

  def to_s
    "/#{url}"
  end
end
