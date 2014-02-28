class PonominaluTicket < ActiveRecord::Base
  alias_attribute :to_s, :title

  attr_accessible :count, :ponominalu_id

  before_save :set_raw_info
  before_save :set_count
  before_save :set_title

  belongs_to :afisha

  scope :available, -> { where 'count > 0' }

  serialize :raw_info, Hashie::Mash

  def min_price
    raw_info.message.min_price
  end

  def max_price
    raw_info.message.max_price
  end

  def link
    "#{raw_info.message.link}?promote=#{Settings['ponominalu.promote']}"
  end

  def price
    min_price == max_price ? "#{min_price}р." : "#{min_price} - #{max_price}р."
  end

  private

  def api_url
    'http://api.cultserv.ru'
  end

  def method
    'jtransport/partner/get_subevent'
  end

  def params
    { :id => ponominalu_id, :session => Settings['ponominalu.session'] }
  end

  def request_url
    "#{api_url}/#{method}?#{params.to_query}"
  end

  def response
    @response ||= HTTParty.get(request_url).parsed_response
  end

  def set_raw_info
    self.raw_info = Hashie::Mash.new(response)
  end

  def response_without_error?
    raw_info.code > 0
  end

  def set_count
    self.count = response_without_error? ? raw_info.message.ticket_count : 0
  end

  def set_title
    self.title = response_without_error? ? raw_info.message.title : ''
  end
end
