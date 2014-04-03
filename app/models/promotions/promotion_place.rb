class PromotionPlace < ActiveRecord::Base
  belongs_to :promotion

  has_many :place_items, :dependent => :destroy

  def random_place_item
    place_items.available.to_a.sample
  end

  def html
    random_place_item.html
  end

  def position
    [1, 2, 3].sample
  end
end
