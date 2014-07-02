class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.references :master, :polymorphic => true
      t.references :slave, :polymorphic => true

      t.timestamps
    end
    add_index :relations, :master_id
    add_index :relations, :slave_id
  end
end
