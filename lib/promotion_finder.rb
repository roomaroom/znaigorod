class PromotionFinder
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def promotion
    return promotion_by_direct_url if promotion_by_direct_url

    return smart_promotion if smart_promotion

    nil
  end

  private

  def promotion_by_direct_url
    @promotion_by_direct_url ||= Promotion.find_by_url(url)
  end

  def smart_promotion
    @smart_promotion ||= begin
                           if url.match(/hotels\/.+/)
                             Promotion.find_by_url('/hotels')
                           end

                           if url.match(/recreation_centers\/.+/)
                             Promotion.find_by_url('/recreation_centers')
                           end

                           if Afisha.kind.values.map(&:pluralize).map { |value| "/#{value}" }.include?(url)
                             Promotion.find_by_url('/afisha')
                           end
                         end
  end
end
