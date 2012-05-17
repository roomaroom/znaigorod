class CreateShowings < ActiveRecord::Migration
  def change
    create_table :showings do |t|
      t.references :affiche
      t.string :place
      t.datetime :starts_at
      t.integer :price
      t.string :hall

      t.timestamps
    end
    add_index :showings, :affiche_id
  end
end
