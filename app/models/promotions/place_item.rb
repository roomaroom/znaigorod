class PlaceItem < ActiveRecord::Base
  alias_attribute :to_s, :url

  attr_accessible :url, :starts_at, :ends_at, :title, :promotion_place_ids

  has_and_belongs_to_many :promotion_places
  has_many :promotions, :through => :promotion_places

  scope :available, -> { where 'starts_at <= :now AND ends_at >= :now', { :now => Time.zone.now } }

  validates :title,     :presence => true
  validates :url,       :presence => true
  validates :starts_at, :presence => true
  validates :ends_at,   :presence => true

  searchable do
    text :title
    text :url
    time :updated_at
  end

  def html
    return nil unless request_success?

    set_title
    set_url
  end

  private

  def absolute_url?
    url.include? 'http://'
  end

  def request_url
    return URI.escape(url) if absolute_url?

    path, query = url.split('?')

    URI.escape "#{Settings['app.url']}#{path}.promotion?#{query}"
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

  def title_pattern
    '%title%'
  end

  def set_title
    encoded_response.gsub! title_pattern, title

    encoded_response
  end

  def url_pattern
    '%item_url%'
  end

  def set_url
    encoded_response.gsub! url_pattern, url

    encoded_response
  end
end

# == Schema Information
#
# Table name: place_items
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  starts_at  :datetime
#  ends_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string(255)
#

