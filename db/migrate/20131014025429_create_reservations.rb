class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :reserveable, :polymorphic => true
      t.text :placeholder
      t.string :phone
      t.string :title
      t.float :balance

      t.timestamps
    end

    add_index :reservations, :reserveable_id
    add_index :reservations, :reserveable_type
  end
end
