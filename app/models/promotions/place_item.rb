class PlaceItem < ActiveRecord::Base
  attr_accessible :url, :starts_at, :ends_at

  belongs_to :promotion_place

  scope :available, -> { where 'starts_at <= :now AND ends_at >= :now', { :now => Time.zone.now } }

  validates :url, :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true

  normalize_attribute(:url) { |value| value.gsub(/^\//, '') }

  def to_s
    "/#{url}"
  end
end
