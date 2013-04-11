class CreateTravels < ActiveRecord::Migration
  def change
    create_table :travels do |t|
      t.text :category
      t.text :description
      t.text :feature
      t.string :title
      t.text :offer
      t.references :organization

      t.timestamps
    end
    add_index :travels, :organization_id
  end
end
