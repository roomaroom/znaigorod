class PromotionWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :promotion

  def perform(url, channel)
    promotion = Promotion.find_by_url(url)

    promotion.promotion_places.each do |place|
      PreparePromotionPlaceWorker.perform_async(place.id, channel)
    end if promotion
  end
end
