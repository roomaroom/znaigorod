class PromotionPlace < ActiveRecord::Base
  belongs_to :promotion

  has_many :place_items, :dependent => :destroy
end
