class CreateOrganizationCategories < ActiveRecord::Migration
  def change
    create_table :organization_categories do |t|
      t.string :title
      t.string :ancestry

      t.timestamps
    end
    add_index :organization_categories, :ancestry
  end
end
