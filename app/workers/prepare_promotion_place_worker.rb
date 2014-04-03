class PreparePromotionPlaceWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :promotion

  def perform(id, channel)
    place    = PromotionPlace.find(id)
    position = place.position
    html     = place.html

    params = {
      :channel => "/promotions/#{channel}",
      :data => {
          :position => position,
          :html     => html
      },
      :ext => {
          :secret => Settings['faye.secret'].to_s
      }
    }

    RestClient.post("#{Settings['faye.url']}/faye", params.to_json, :content_type => :json, :accept => :json)
  end
end
