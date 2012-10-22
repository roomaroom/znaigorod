class CreateSaunaBrooms < ActiveRecord::Migration
  def up
    create_table :sauna_brooms do |t|
      t.references :sauna
      t.integer :ability
      t.integer :sale

      t.timestamps
    end
    add_index :sauna_brooms, :sauna_id

    remove_column :sauna_accessories, :ability_brooms
    remove_column :sauna_accessories, :brooms
  end

  def down
    drop_table :sauna_brooms

    add_column :sauna_accessories, :ability_brooms, :integer
    add_column :sauna_accessories, :brooms, :integer
  end
end
