class PlaceItem < ActiveRecord::Base
  alias_attribute :to_s, :url

  attr_accessible :url, :starts_at, :ends_at

  belongs_to :promotion_place

  scope :available, -> { where 'starts_at <= :now AND ends_at >= :now', { :now => Time.zone.now } }

  validates :url, :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true

  def html
    HTTParty.get(request_url).parsed_response.force_encoding('utf-8')
  end

  private

  def request_url
    "#{Settings['app.url']}#{url}.promotion"
  end
end
