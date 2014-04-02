class PromotionPlace < ActiveRecord::Base
  belongs_to :promotion

  has_many :place_items, :dependent => :destroy

  def place_items_sample(n = 1)
    place_items.available.to_a.sample(n)
  end
end
