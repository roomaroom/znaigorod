class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :house
      t.references :organization

      t.timestamps
    end
    add_index :addresses, :organization_id
  end
end
