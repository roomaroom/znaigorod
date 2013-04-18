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
    { "category" => 0.5, "feature" => 0.3, "offer" => 0.3, "virtual_tour" => 0.5 }
  end

  def billiard_hash
    { "category" => 0.5, "feature" => 0.3, "offer" => 0.3, "virtual_tour" => 0.5 }
  end

  def sport_hash
    { "title" => 1 }
  end

  def culture_hash
    { "category" => 0.5, "feature" => 0.3, "offer" => 0.3 }
  end

  def car_wash_hash
    { "category" => 0.5, "feature" => 0.5, "offer" => 0.5 }
  end

  def salon_center_hash
    { "category" => 0.5, "feature" => 0.5, "offer" => 0.5 }
  end

  def creation_hash
    { "title" => 0.5 }
  end

  def car_sales_center_hash
    { "category" => 0.5, "feature" => 0.5, "offer" => 0.5 }
  end

  def sauna_hash
    { "category" => 0.5, "feature" => 0.5, "offer" => 0.5, "virtual_tour" => 0.5 }
  end

  def virtual_tour_hash
    { "link" => 1 }
  end

  def sauna_accessory_hash
    { "sheets" => 0.5, "sneakers" => 0.5, "bathrobes" => 0.5, "towels" => 0.5 }
  end

  def sauna_broom_hash
    { "ability" => 0.5, "sale" => 0.5 }
  end

  def sauna_alcohol_hash
    { "ability_own" => 0.5, "sale" => 0.5 }
  end

  def sauna_oil_hash
    { "ability" => 0.5, "sale" => 0.5 }
  end

  def sauna_child_stuff_hash
   { "life_jacket" => 0.5, "cartoons" => 0.5, "games" => 0.5, "rubber_ring" => 0.5 }
  end

  def sauna_stuff_hash
    { "wifi" => 0.5, "safe" => 0.5 }
  end

  def sauna_massage_hash
    { "classical" => 0.5, "spa" => 0.5, "anticelltilitis" => 0.5 }
  end

  def sauna_hall_hash
    { "description" => 0.5 }
  end

  def sauna_hall_bath_hash
    { "russian" => 0.5, "finnish" => 0.5, "turkish" => 0.5, "japanese" => 0.5, "infrared" => 0.5,  }
  end

  def sauna_hall_capacity_hash
    { "maximal" => 0.5, "extra_guest_cost" => 0.5 }
  end

  def sauna_hall_entertainment_hash
    { "karaoke" => 0.5, "tv" => 0.5, "billiard" => 0.5, "ping_pong" => 0.5, "hookah" => 0.5, "aerohockey" => 0.5, "checkers" => 0.5,
      "backgammon" => 0.5, "guitar" => 0.5 }
  end

  def sauna_hall_interior_hash
    { "floors" => 0.5, "lounges" => 0.5, "pit" => 0.5, "pylon" => 0.5, "barbecue" => 0.5 }
  end

  def sauna_hall_pool_hash
    { "size" => 0.5, "contraflow" => 0.5, "geyser" => 0.5, "waterfall" => 0.5, "water_filter" => 0.5, "jacuzzi" => 0.5, "bucket" => 0.5 }
  end

  private

  def quality_rating
    if self.priority_suborganization_kind == 'sauna'
      @quality_rating ||= 0.4*sauna_fullness_rating + 0.3*images_rating + 0.3*sauna_hall_images_rating
    else
      @quality_rating ||= 0.3*fullness_rating + 0.5*affiches_rating + 0.2*images_rating
    end
  end

  def affiches_rating
    [nearest_affiches.count, 2].min * 0.5
  end

  def images_rating
    [images.count, 10].min * 0.1
  end

  def sauna_hall_images_rating
    images = 0
    self.suborganizations.each do |suborganization|
      if suborganization.is_a?(Sauna)
        suborganization.sauna_halls.each do |sauna_hall|
          images += [sauna_hall.images.count, 5].min * 0.2
        end
        images /= (suborganization.sauna_halls.any? ? suborganization.sauna_halls.count : 1)
      end
    end
    images
  end

  def fullness_rating
    sum = 0
    sum += calculate_fullness_rating(self)
    self.suborganizations.each do |suborganization|
      sum += calculate_fullness_rating(suborganization)
    end

    sum /= (suborganizations.count + 1)
  end

  def sauna_fullness_rating
    sum = 0
    sum += calculate_fullness_rating(self)
    hall_count = 13
    self.suborganizations.each do |suborganization|
      sum += calculate_fullness_rating(suborganization)

      if suborganization.is_a?(Sauna)
        hall_count += suborganization.sauna_halls.count

        associations =  Sauna.reflect_on_all_associations(:has_one).map(&:name) - [:virtual_tour]

        associations.each do |association|
          sum += calculate_fullness_rating(suborganization.send(association))
        end

        suborganization.sauna_halls.each do |sauna_hall|
          associations = SaunaHall.reflect_on_all_associations(:has_one).map(&:name) - [:address, :organization, :virtual_tour]
          associations.each do |association|
            sum += calculate_fullness_rating(sauna_hall.send(association))
          end
        end
      end
    end

    sum /= (suborganizations.count + hall_count + 1)
  end

  def calculate_fullness_rating(object)
    filled_attributes = object.attributes.select{|k,v| !v.nil? && v.to_s.present?}
    hash = send("#{object.class.name.underscore}_hash")
    sum = filled_attributes.inject(0) { |sum, obj| sum += hash[obj.first].to_f; sum }

    sum += hash["virtual_tour"] if object.respond_to?(:vitrual_tour) && object.virtual_tour.link?

    sum.to_f / hash.values.inject(:+)
  end

end
