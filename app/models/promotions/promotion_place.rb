class PromotionPlace < ActiveRecord::Base
  after_create    :set_position

  belongs_to :promotion

  has_and_belongs_to_many :place_items

  #alias_attribute :to_s, :position

  def random_place_item
    @random_place_item ||= place_items.available.to_a.sample
  end

  def to_s
    position.to_s
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
