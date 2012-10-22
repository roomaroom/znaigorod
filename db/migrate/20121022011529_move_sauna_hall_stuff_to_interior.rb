class MoveSaunaHallStuffToInterior < ActiveRecord::Migration
  def up
    drop_table :sauna_hall_stuffs

    add_column :sauna_hall_interiors, :pit, :integer
    add_column :sauna_hall_interiors, :pylon, :integer
    add_column :sauna_hall_interiors, :barbecue, :integer
  end

  def down
    create_table :sauna_hall_stuffs do |t|
      t.references :sauna_hall
      t.integer :pit
      t.integer :pylon
      t.integer :barbecue

      t.timestamps
    end
    add_index :sauna_hall_stuffs, :sauna_hall_id

    remove_column :sauna_hall_interiors, :pit
    remove_column :sauna_hall_interiors, :pylon
    remove_column :sauna_hall_interiors, :barbecue
  end
end
