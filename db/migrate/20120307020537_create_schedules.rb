class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :day
      t.time :from
      t.time :to
      t.references :organization

      t.timestamps
    end
  end
end
