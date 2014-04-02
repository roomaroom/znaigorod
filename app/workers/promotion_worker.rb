require 'curb'

class PromotionWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :promotion

  def perform(url, channel)
    Promotion.find_by_url(url).promotion_places.each do |place|
      PreparePromotionPlaceWorker.perform_async(place.id, channel)
    end
  end
end