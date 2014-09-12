class Add < ActiveRecord::Migration
  def up
    add_column :organizations, :page_meta_description, :text
    add_column :organizations, :page_meta_keywords, :text
  end

  def down
    remove_column :organizations, :page_meta_description
    remove_column :organizations, :page_meta_keywords
  end
end
