class AddPageMetaTitleToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :page_meta_title, :text
  end
end
