class MoveSaunaHallWaterAccessoryToPool < ActiveRecord::Migration
  def up
    add_column :sauna_hall_pools, :jacuzzi, :integer
    add_column :sauna_hall_pools, :bucket, :integer

    drop_table :sauna_hall_water_accessories
  end

  def down
    create_table :sauna_hall_water_accessories do |t|
      t.references :sauna_hall
      t.integer :jacuzzi
      t.integer :bucket

      t.timestamps
    end
    add_index :sauna_hall_water_accessories, :sauna_hall_id

    remove_column :sauna_hall_pools, :jacuzzi
    remove_column :sauna_hall_pools, :bucket
  end
end
