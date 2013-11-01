# encoding: utf-8

require 'progress_bar'

class Discount < ActiveRecord::Base
  belongs_to :organization
end

class CreatePlacesForDiscounts < ActiveRecord::Migration
  def up
    discounts = Discount.all
    bar = ProgressBar.new(discounts.count)

    discounts.each do |discount|
      if discount.organization_id?
        organization = discount.organization
        address = "#{organization.address.street}, #{organization.address.house}"
        discount.places.create! :organization_id => organization.id,
                                :address => address,
                                :latitude => organization.address.latitude,
                                :longitude => organization.address.longitude
      else
        place = discount.places.new
        place.address = discount.place
        place.save :validate => false
      end
      bar.increment!
    end

    remove_column :discounts, :organization_id
    remove_column :discounts, :place
  end

  def down
  end
end
