class CreateSaunaOils < ActiveRecord::Migration
  def up
    create_table :sauna_oils do |t|
      t.references :sauna
      t.integer :ability
      t.boolean :sale

      t.timestamps
    end
    add_index :sauna_oils, :sauna_id

    remove_column :sauna_accessories, :oils
    remove_column :sauna_accessories, :ability_oils
  end

  def down
    drop_table :sauna_oils

    add_column :sauna_accessories, :oils, :integer
    add_column :sauna_accessories, :ability_oils, :integer
  end
end
