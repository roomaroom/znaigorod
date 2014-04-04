class PlaceItem < ActiveRecord::Base
  alias_attribute :to_s, :url

  attr_accessible :url, :starts_at, :ends_at, :title

  belongs_to :promotion_place

  scope :available, -> { where 'starts_at <= :now AND ends_at >= :now', { :now => Time.zone.now } }

  validates :url, :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true

  def html
    return nil unless request_success?

    set_title_for(encoded_response)
  end

  private

  def request_url
    "#{Settings['app.url']}#{url}.promotion"
  end

  def response
    @response ||= HTTParty.get(request_url)
  end

  def request_success?
    response.code == 200
  end

  def parsed_response
    @parsed_response ||= response.parsed_response
  end

  def encoded_response
    @encoded_response ||= parsed_response.force_encoding('utf-8')
  end

  def set_title_for(html)
    html.gsub '_title_', title
  end
end
