class AddExpiresAtForPlacemark < ActiveRecord::Migration
  def up
    add_column :map_placemarks, :expires_at, :datetime

    require 'progress_bar'
    bar = ProgressBar.new(MapPlacemark.count)

    MapPlacemark.all.each do |mark|
      mark.update_attribute(:expires_at, Time.zone.now + 7.days)
      bar.increment!
    end
  end

  def down
    remove_column :map_placemarks, :expires_at
  end
end
