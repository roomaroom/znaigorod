class Promotion < ActiveRecord::Base
  attr_accessible :url

  has_many :promotion_places, :dependent => :destroy

  scope :ordered, -> { order :url }

  validates :url, :presence => true, :uniqueness => true

  normalize_attribute(:url) { |value| value.gsub(/^\//, '') }

  def to_s
    "/#{url}"
  end
end
