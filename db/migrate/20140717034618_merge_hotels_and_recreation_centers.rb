class MergeHotelsAndRecreationCenters < ActiveRecord::Migration
  def up
    RecreationCenter.all.each do |center|
      hotel = if center.organization.hotel.present?
        center.organization.hotel
      else
        Hotel.create center.attributes.except("id","created_at","updated_at")
      end

      center.rooms.each do |room|
        room.context = hotel
        room.save!
      end

      center.destroy
    end

    drop_table :recreation_centers
  end

  def down
  end
end
