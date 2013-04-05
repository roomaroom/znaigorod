require 'active_support/concern'

module OrganizationQualityRating
  extend ActiveSupport::Concern

  include Rateable

  SKIPPED_ATTRIBUTES = /^id$|^created_at$|^updated_at$|^rating$|^comment$|^slug$|_id$|_rating$|^yandex|^vkontakte/

  private

  def quality_rating
    @quality_rating ||= 0.6*fullness_rating + 0.1*affiches_rating + 0.3*images_rating
  end

  def self_fullness_rating
    Rateable.calculate_fullness_rating(self, :skip => SKIPPED_ATTRIBUTES)
  end

  def fullness_rating
    sum_ratings = suborganizations.inject(self_fullness_rating) do |sum, suborganization|
      sum += Rateable.calculate_fullness_rating(suborganization, :skip => SKIPPED_ATTRIBUTES)
    end
    sum_ratings / (suborganizations.count + 1)
  end

  def affiches_rating
    [nearest_affiches.count, 10].min * 0.1
  end

  def images_rating
    [images.count, 10].min * 0.1
  end
end
