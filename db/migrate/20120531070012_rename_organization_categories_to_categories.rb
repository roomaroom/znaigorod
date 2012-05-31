class RenameOrganizationCategoriesToCategories < ActiveRecord::Migration
  def change
    rename_column :organizations, :organization_categories, :categories
  end
end
