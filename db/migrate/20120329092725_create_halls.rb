class CreateHalls < ActiveRecord::Migration
  def change
    create_table :halls do |t|
      t.string :title
      t.integer :seating_capacity
      t.references :organization

      t.timestamps
    end
    add_index :halls, :organization_id
  end
end
