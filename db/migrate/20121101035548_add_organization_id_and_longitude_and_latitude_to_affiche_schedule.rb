class AddOrganizationIdAndLongitudeAndLatitudeToAfficheSchedule < ActiveRecord::Migration
  def change
    add_column :affiche_schedules, :organization_id, :integer
    add_column :affiche_schedules, :latitude, :string
    add_column :affiche_schedules, :longitude, :string
  end
end
