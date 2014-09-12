class AddMetaTagsForPhotogallery < ActiveRecord::Migration
  def up
    add_column :photogalleries, :page_meta_description, :text
    add_column :photogalleries, :page_meta_keywords, :text
  end

  def down
    remove_column :photogalleries, :page_meta_keywords
    remove_column :photogalleries, :page_meta_description
  end
end
