class CreateVirtualTours < ActiveRecord::Migration
  def change
    create_table :virtual_tours do |t|
      t.string :link
      t.references :tourable, :polymorphic => true

      t.timestamps
    end
    add_index :virtual_tours, [:tourable_id, :tourable_type]
  end
end
