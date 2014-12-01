include ImageHelper

class MapPlacemark < ActiveRecord::Base
  attr_accessor :related_items
  attr_accessible :title, :map_layer_id, :related_items

  validates_presence_of :map_layer_id, :related_items
  after_save :parse_related_item
  before_save :set_address

  belongs_to :map_layer

  has_many :relations,             :as => :master,         :dependent => :destroy
  has_many :afishas,        :through => :relations, :source => :slave, :source_type => Afisha
  has_many :organizations,  :through => :relations, :source => :slave, :source_type => Organization
  has_many :reviews,        :through => :relations, :source => :slave, :source_type => Review
  has_many :photogalleries, :through => :relations, :source => :slave, :source_type => Photogallery

  def parse_related_item
    relations.destroy_all

    related_items.each do |item|
      slave_type, slave_id = item.split("_")

      relation = relations.new
      relation.slave_type = slave_type.classify
      relation.slave_id = slave_id

      relation.save
    end
  end

  def set_address
    related_items.each do |item|
      item_type, item_id = item.split("_")
      class_item = item_type.classify.constantize.find(item_id)
      if class_item.is_a? Organization
        self.title = class_item.title
        self.latitude = class_item.latitude
        self.longitude = class_item.longitude
        self.image_url = resized_image_url(class_item.logotype_url, 190, 190)
        self.address = class_item.address.to_s
        self.url = "/organizations/#{class_item.slug}"
      else
        self.title = class_item.title
        self.latitude = class_item.organization.latitude
        self.longitude = class_item.organization.longitude
        self.image_url = resized_image_url(class_item.poster_url, 190, 260)
        self.address = class_item.address
        self.when = "#{item_type.classify}Decorator".constantize.new(class_item).human_when
        self.url = "/#{item_type}/#{class_item.slug}"
      end
    end
  end
end

# == Schema Information
#
# Table name: map_placemarks
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  latitude     :float
#  longitude    :float
#  image_url    :string(255)
#  url          :string(255)
#  address      :string(255)
#  when         :string(255)
#  map_layer_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

