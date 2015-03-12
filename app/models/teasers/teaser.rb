class Teaser < ActiveRecord::Base
  extend FriendlyId

  attr_accessor :related_items, :need_change

  attr_accessible :items_quantity, :title, :with_relations, :related_items,
                  :need_change, :slug

  validates_presence_of :title
  validates_presence_of :items_quantity, :unless => :with_relations
  has_many :teaser_items, :dependent => :destroy
  has_many :relations,             as: :master,            dependent: :destroy

  after_create :create_teaser_items, :unless => :with_relations
  after_save :parse_related_items, :if => :with_relations

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

  def parse_related_items
    relations.destroy_all if related_items.nil?
    return true unless related_items
    relations.destroy_all

    related_items.each do |item|
      slave_type, slave_id = item.split("_")

      relation = relations.new
      relation.slave_type = slave_type.classify
      relation.slave_id = slave_id

      relation.save
    end
  end
end

# == Schema Information
#
# Table name: teasers
#
#  id             :integer          not null, primary key
#  items_quantity :integer
#  border_color   :string(255)
#  title          :string(255)
#  slug           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  with_relations :boolean
#

