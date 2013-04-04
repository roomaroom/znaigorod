require 'active_support/concern'

module QualityRating
  extend ActiveSupport::Concern

  included do
    after_save :recalculate_rating
    has_many :user_ratings
  end

  module ClassMethods
    SKIPED_ATTRIBUTES = /^id$|^created_at$|^updated_at$|^rating$|^comment$|^slug$|_id$|_rating$|^yandex|^vkontakte/
    ATRRIBUTE_MODELS = [:address, :social_links]

    def calculate_fullness_rating(object)
      attributes = object.attributes.delete_if{|k,v| k =~ SKIPED_ATTRIBUTES }
      filled_attributes = attributes.select{|k,v| !v.nil? && v.to_s.present? }
      1.0 * filled_attributes.count / attributes.count
    end
  end

  def recalculate_rating
    update_column(:total_rating, calculate_total_rating)
  end

  private

  def calculate_total_rating
    user_rating - (user_rating - quality_rating) / (user_ratings.count + 1)**((user_ratings.count * 0.02)/(user_rating + 0.1))
  end

  def user_rating
    @user_rating ||= user_ratings.average(:value).to_i / 4.0
  end

  def quality_rating
    @quality_rating ||= 0.6*fullness_rating + 0.1*affiches_rating + 0.3*images_rating
  end

  def self_fullness_rating
    Organization.calculate_fullness_rating(self)
  end

  def fullness_rating
    sum_ratings = suborganizations.inject(self_fullness_rating) do |sum, suborganization|
      sum += Organization.calculate_fullness_rating(suborganization)
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
