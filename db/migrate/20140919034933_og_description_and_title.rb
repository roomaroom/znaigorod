class OgDescriptionAndTitle < ActiveRecord::Migration
  def up
    add_column :organizations, :og_description, :text
    add_column :organizations, :og_title, :text
  end

  def down
    remove_column :organizations, :og_description
    remove_column :organizations, :og_title
  end
end
