class PromotionWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :promotion

  def perform(url, channel)
    smart_promotion = PromotionFinder.new
    promotion = smart_promotion.promotion

    promotion.promotion_places.each do |place|
      PreparePromotionPlaceWorker.perform_async(place.id, channel)
    end if promotion
  end
end
