class CreateAfficheSchedules < ActiveRecord::Migration
  def change
    create_table :affiche_schedules do |t|
      t.references :affiche
      t.date :starts_on
      t.date :ends_on
      t.time :starts_at
      t.time :ends_at
      t.string :holidays
      t.string :place
      t.string :hall

      t.timestamps
    end
    add_index :affiche_schedules, :affiche_id
  end
end
