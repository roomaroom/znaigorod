class CreateCreations < ActiveRecord::Migration
  def change
    create_table :creations do |t|
      t.references :organization
      t.string :title
      t.text :description

      t.timestamps
    end
    add_index :creations, :organization_id
  end
end
