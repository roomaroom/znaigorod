class CreateSaunaAlcohols < ActiveRecord::Migration
  def up
    create_table :sauna_alcohols do |t|
      t.references :sauna
      t.integer :ability_own
      t.boolean :sale

      t.timestamps
    end
    add_index :sauna_alcohols, :sauna_id

    remove_column :sauna_accessories, :ability_own_alcohol
    remove_column :sauna_accessories, :alcohol_for_sale
  end

  def down
    drop_table :sauna_alcohols

    add_column :sauna_accessories, :ability_own_alcohol, :integer
    add_column :sauna_accessories, :alcohol_for_sale, :boolean
  end
end
