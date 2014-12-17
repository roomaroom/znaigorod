class Teaser < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :image_height, :image_width, :items_quantity, :title,
                  :background_color, :border_color, :text_color, :link_color

  validates_presence_of :title, :items_quantity, :image_width, :image_height
  has_many :teaser_items, :dependent => :destroy

  after_create :create_teaser_items

  friendly_id :title, :use => :slugged
  def should_generate_new_friendly_id?
    return true if !self.slug?

    false
  end

  private

  def create_teaser_items
    (1..self.items_quantity).each do
      teaser_items.create
    end
  end
end

# == Schema Information
#
# Table name: teasers
#
#  id               :integer          not null, primary key
#  items_quantity   :integer
#  image_width      :integer
#  image_height     :integer
#  background_color :string(255)
#  border_color     :string(255)
#  text_color       :string(255)
#  link_color       :string(255)
#  title            :string(255)
#  slug             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

