require 'progress_bar'

class MigrateVirtualToursFromOrganizations < ActiveRecord::Migration
  def migrate_tours(clazz)
    puts "migrating #{clazz}"
    scope = clazz.where("tour_link IS NOT NULL and tour_link <> ''")
    bar = ProgressBar.new(scope.count)
    scope.find_each do |object|
      object.update_attributes! :virtual_tour_attributes => { :link => object.tour_link } if object.tour_link?
      bar.increment!
    end
  end

  def up
    migrate_tours(Organization)
    migrate_tours(SaunaHall)
  end

  def down
    VirtualTour.delete_all
  end
end
