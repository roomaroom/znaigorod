# encoding: utf-8

module CropedPoster
  extend ActiveSupport::Concern

  included do
    attr_accessible :set_region, :crop_x, :crop_y, :crop_width, :crop_height, :poster_image

    attr_accessor :set_region, :crop_x, :crop_y, :crop_width, :crop_height

    has_attached_file :poster_image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

    validates_attachment :poster_image, :presence => true, :content_type => {
      :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
      :message => 'Изображение должно быть в формате jpeg, jpg или png' },             :if => :poster_image?

    validates :poster_image, :dimensions => { :width_min => 300, :height_min => 300 }, :if => :poster_image?

    after_validation :set_poster_url, :if => :set_region?
  end

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

  private

  def set_poster_url
    if poster_image_url?
      rpl = 'region/' << [crop_width, crop_height, crop_x, crop_y].map(&:to_f).map { |v| v * resize_factor }.map(&:round).join('/')
      self.poster_url = poster_image_url.gsub(/\/\d+-\d+\//, "/#{rpl}/")
    end
  end
end
