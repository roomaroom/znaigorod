class RenameCategoryToTitleForServices < ActiveRecord::Migration
  def up
    rename_column :services, :category, :title
  end

  def down
    rename_column :services, :title, :category
  end
end
