class CreateRecreationCenters < ActiveRecord::Migration
  def change
    create_table :recreation_centers do |t|
      t.references :organization
      t.string :title
      t.text :category
      t.text :description
      t.text :feature
      t.text :offer

      t.timestamps
    end
    add_index :recreation_centers, :organization_id
  end
end
