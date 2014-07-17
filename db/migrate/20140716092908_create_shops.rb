class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.references :organization
      t.text :category
      t.text :feature
      t.text :offer
      t.string :payment
      t.string :title
      t.text :description

      t.timestamps
    end
    add_index :shops, :organization_id
  end
end
