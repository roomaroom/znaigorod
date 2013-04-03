class CreateSalonCenters < ActiveRecord::Migration
  def change
    create_table :salon_centers do |t|
      t.text :category
      t.text :description
      t.text :feature
      t.string :title
      t.text :offer
      t.references :organization

      t.timestamps
    end
    add_index :salon_centers, :organization_id
  end
end
