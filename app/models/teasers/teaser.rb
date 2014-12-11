class Teaser < ActiveRecord::Base
  attr_accessible :image_height, :image_width, :items_quantity, :text_length, :title

  has_many :teaser_items, :dependent => :destroy

  after_create :create_teaser_items

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
#  id             :integer          not null, primary key
#  items_quantity :integer
#  image_width    :integer
#  image_height   :integer
#  text_length    :integer
#  title          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

