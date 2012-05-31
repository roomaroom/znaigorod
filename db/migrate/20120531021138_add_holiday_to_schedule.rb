class AddHolidayToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :holiday, :boolean
  end
end
