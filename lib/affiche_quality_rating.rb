require 'active_support/concern'

module AfficheQualityRating
  extend ActiveSupport::Concern

  include Rateable

  SKIPPED_ATTRIBUTES = /^popularity$|^original_title$|^constant$|^distribution_|^image_url$/

  private

  def quality_rating
    @quality_rating ||= 0.5*organization_rating + 0.3*fullness_rating + 0.2*images_rating
  end

  def organization_rating
    organizations.average(:total_rating) || 0.7
  end

  def fullness_rating
    Rateable.calculate_fullness_rating(self, :skip => SKIPPED_ATTRIBUTES)
  end

  def images_rating
    [images.count, 10].min * 0.1
  end
end
