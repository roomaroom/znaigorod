require 'active_support/concern'

module OrganizationQualityRating
  extend ActiveSupport::Concern

  include Rateable

  SKIPED_ATTRIBUTES = /^id$|^created_at$|^updated_at$|^rating$|^comment$|^slug$|_id$|_rating$|^yandex|^vkontakte/
  ATRRIBUTE_MODELS = [:address, :social_links]

  def self.calculate_fullness_rating(object)
    attributes = object.attributes.delete_if{|k,v| k =~ SKIPED_ATTRIBUTES }
    filled_attributes = attributes.select{|k,v| !v.nil? && v.to_s.present? }
    1.0 * filled_attributes.count / attributes.count
  end

  private

  def quality_rating
    @quality_rating ||= 0.6*fullness_rating + 0.1*affiches_rating + 0.3*images_rating
  end

  def self_fullness_rating
    OrganizationQualityRating.calculate_fullness_rating(self)
  end

  def fullness_rating
    sum_ratings = suborganizations.inject(self_fullness_rating) do |sum, suborganization|
      sum += OrganizationQualityRating.calculate_fullness_rating(suborganization)
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
