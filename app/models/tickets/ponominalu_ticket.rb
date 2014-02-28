class PonominaluTicket < ActiveRecord::Base
  attr_accessible :count, :ponominalu_id

  before_save :get_raw_info
  before_save :set_count

  belongs_to :afisha

  scope :available, -> { where 'count > 0' }

  serialize :raw_info, Hashie::Mash

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

  def get_raw_info
    self.raw_info = Hashie::Mash.new(response)
  end

  def response_without_error?
    raw_info.code > 0
  end

  def set_count
    self.count = response_without_error? ? raw_info.message.ticket_count : 0
  end
end
