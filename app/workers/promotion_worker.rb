class PromotionWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :promotion

  def perform(url, channel, subdomain)
    begin
      smart_promotion = PromotionFinder.new(url, subdomain)
      promotion = smart_promotion.promotion

      promotion.promotion_places.each do |place|
        PreparePromotionPlaceWorker.perform_async(place.id, channel)
      end if promotion
    rescue
    end
  end
end
