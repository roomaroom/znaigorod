class RenameCategoriesInOrganizations < ActiveRecord::Migration
  def change
    rename_column :organizations, :category, :organization_categories
  end
end
