class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.text :category
      t.text :description
      t.text :feature
      t.string :title
      t.text :offer
      t.references :organization

      t.timestamps
    end
    add_index :hotels, :organization_id
  end
end
