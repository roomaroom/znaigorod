require 'active_support/concern'

module OrganizationQualityRating
  extend ActiveSupport::Concern

  include Rateable

  def organization_hash
    { "email" => 0.3, "logotype_url" => 1, "non_cash" => 0.5, "phone" => 0.5, "site" => 1, "subdomain" => 1, "virtual_tour" => 1 }
  end

  def meal_hash
    { "category" => 0.7, "feature" => 0.7, "offer" => 0.7, "cuisine" => 1, "virtual_tour" => 0.5 }
  end

  def entertainment_hash
    { "category" => 1, "feature" => 1, "offer" => 1, "virtual_tour" => 0.5 }
  end

  def billiard_hash
    { "category" => 1, "feature" => 1, "offer" => 1, "virtual_tour" => 0.5 }
  end

  private

  def quality_rating
    @quality_rating ||= 0.3*fullness_rating + 0.5*affiches_rating + 0.3*images_rating
  end

  def affiches_rating
    [nearest_affiches.count, 10].min * 0.1
  end

  def images_rating
    [images.count, 10].min * 0.1
  end

  def fullness_rating
    sum = ([self] + suborganizations).map { |obj| calculate_fullness_rating(obj) }.inject(:+)

    sum /= (suborganizations.count + 1)
  end

  def calculate_fullness_rating(object)
    filled_attributes = object.attributes.select{|k,v| !v.nil? && v.to_s.present?}
    hash = send("#{object.class.name.underscore}_hash")
    sum = filled_attributes.inject(0) { |sum, obj| sum += hash[obj.first].to_f; sum }

    sum += hash["virtual_tour"] if object.virtual_tour.link?

    sum.to_f / hash.values.inject(:+)
  end

end
