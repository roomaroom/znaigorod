class PromotionPlace < ActiveRecord::Base
  after_create :set_position

  belongs_to :promotion

  has_many :place_items, :dependent => :destroy

  def random_place_item
    @random_place_item ||= place_items.available.to_a.sample
  end

  def html
    random_place_item.try(:html)
  end

  private

  def set_position
    self.position = promotion.promotion_places.count

    save
  end
end
