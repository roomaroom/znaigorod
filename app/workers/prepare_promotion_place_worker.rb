class PreparePromotionPlaceWorker
  include Sidekiq::Worker

  attr_accessor :place

  sidekiq_options :queue => :promotion

  def perform(id, channel)
    find_promotion_place(id)

    begin
      send_request_to_faye(channel) if place.html
    rescue
    end
  end

  private

  def find_promotion_place(id)
    @place ||= PromotionPlace.find(id)
  end

  def send_request_to_faye(channel)
    params = {
      :channel => "/promotions/#{channel}",
      :data => {
        :position => place.position,
        :html     => place.html
      },
      :ext => {
        :secret => Settings['faye.secret'].to_s
      }
    }

    begin
      RestClient.post("#{Settings['faye.url']}/faye", params.to_json, :content_type => :json, :accept => :json)
    rescue
    end
  end
end
