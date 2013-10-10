# encoding: utf-8

class Discount < ActiveRecord::Base
  attr_accessible :title, :description, :ends_at, :kind, :starts_at,
                  :discount, :organization_id, :poster_image, :poster_url,
                  :set_region, :crop_x, :crop_y, :crop_width, :crop_height

  attr_accessor :set_region, :crop_x, :crop_y, :crop_width, :crop_height

  belongs_to :account
  belongs_to :organization

  validates_presence_of :title, :description, :kind, :starts_at, :ends_at, :discount, :kind

  extend Enumerize
  serialize :kind, Array
  enumerize :kind, :in => [:beauty, :entertainment, :sport], :multiple => true, :predicates => true
  normalize_attribute :kind, with: :blank_array

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_attached_file :poster_image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :poster_image, :presence => true, :content_type => {
    :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате jpeg, jpg или png' },                :unless => :set_region?

  validates :poster_image, :dimensions => { :width_min => 300, :height_min => 300 },    :unless => :set_region?

  after_validation :set_poster_url, :if => :set_region?

  def poster_image_original_dimensions
    @poster_image_original_dimensions ||= {}.tap { |dimensions|
      dimensions[:width] = poster_image_url.match(/\/(?<dimensions>\d+-\d+)\//)[:dimensions].split('-').first.to_i
      dimensions[:height] = poster_image_url.match(/\/(?<dimensions>\d+-\d+)\//)[:dimensions].split('-').last.to_i
    }
  end

  def set_region?
    set_region.present?
  end

  def side_max_size
    580.to_f
  end

  def resize_factor
    @resize_factor = poster_image_original_dimensions.values.max / side_max_size

    (@resize_factor < 1) ? 1.0 : @resize_factor
  end

  def poster_image_resized_dimensions
    return poster_image_original_dimensions if poster_image_original_dimensions.values.max < side_max_size

    {}.tap { |dimensions|
      dimensions[:width] = (poster_image_original_dimensions[:width] / resize_factor).round
      dimensions[:height] = (poster_image_original_dimensions[:height] / resize_factor).round
    }
  end

  def set_poster_url
    if poster_image_url?
      rpl = 'region/' << [crop_width, crop_height, crop_x, crop_y].map(&:to_f).map { |v| v * resize_factor }.map(&:round).join('/')
      self.poster_url = poster_image_url.gsub(/\/\d+-\d+\//, "/#{rpl}/")
    end
  end
  private :set_poster_url
end

# == Schema Information
#
# Table name: discounts
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  description               :text
#  poster_url                :text
#  type                      :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  poster_image_url          :text
#  starts_at                 :datetime
#  ends_at                   :datetime
#  slug                      :string(255)
#  total_rating              :float
#  kind                      :text
#  number                    :integer
#  origin_price              :integer
#  price                     :integer
#  discounted_price          :integer
#  discount                  :integer
#  payment_system            :string(255)
#  state                     :string(255)
#  origin_url                :text
#  organization_id           :integer
#  account_id                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

