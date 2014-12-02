include ImageHelper

class MapPlacemark < ActiveRecord::Base
  attr_accessor :related_items
  attr_accessible :title, :map_layer_id, :related_items, :latitude, :longitude, :url, :address,
                  :image

  validates_presence_of :map_layer_id
  before_save :parse_related_items

  belongs_to :map_layer

  has_many :relations,             :as => :master,         :dependent => :destroy
  has_many :afishas,        :through => :relations, :source => :slave, :source_type => Afisha
  has_many :organizations,  :through => :relations, :source => :slave, :source_type => Organization
  has_many :reviews,        :through => :relations, :source => :slave, :source_type => Review
  has_many :photogalleries, :through => :relations, :source => :slave, :source_type => Photogallery

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  def parse_related_items
    return if related_items.nil?

    relations.destroy_all

    related_items.each do |item|
      slave_type, slave_id = item.split("_")

      relation = relations.new
      relation.slave_type = slave_type.classify
      relation.slave_id = slave_id

      relation.save
    end

    relations.each do |relation|
      relation = relation.slave
      if relation.is_a? Organization
        self.title = relation.title
        self.latitude = relation.latitude
        self.longitude = relation.longitude
        self.image_url = resized_image_url(relation.logotype_url, 190, 190)
        self.address = relation.address.to_s
        self.url = "/organizations/#{relation.slug}"
      else
        self.title = relation.title
        self.latitude = relation.organization.latitude
        self.longitude = relation.organization.longitude
        self.image_url = resized_image_url(relation.poster_url, 190, 260)
        self.address = relation.address
        self.when = "#{relation.class.name}Decorator".constantize.new(relation).human_when
        self.url = "/afisha/#{relation.slug}"
      end
    end
  end
end

# == Schema Information
#
# Table name: map_placemarks
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  latitude           :float
#  longitude          :float
#  image_url          :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :string(255)
#  url                :string(255)
#  address            :string(255)
#  when               :string(255)
#  map_layer_id       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

