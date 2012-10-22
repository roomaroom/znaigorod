class ChangePitPylonAndBarbecue < ActiveRecord::Migration
  def up
    remove_column :sauna_hall_interiors, :pit
    remove_column :sauna_hall_interiors, :pylon
    remove_column :sauna_hall_interiors, :barbecue

    add_column :sauna_hall_interiors, :pit, :boolean
    add_column :sauna_hall_interiors, :pylon, :boolean
    add_column :sauna_hall_interiors, :barbecue, :boolean
  end

  def down
    remove_column :sauna_hall_interiors, :barbecue
    remove_column :sauna_hall_interiors, :pylon
    remove_column :sauna_hall_interiors, :pit

    add_column :sauna_hall_interiors, :barbecue
    add_column :sauna_hall_interiors, :pylon
    add_column :sauna_hall_interiors, :pit
  end
end
