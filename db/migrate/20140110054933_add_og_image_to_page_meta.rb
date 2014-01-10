class AddOgImageToPageMeta < ActiveRecord::Migration
  def up
    add_attachment :page_meta, :og_image
  end

  def down
    remove_attachment :page_meta, :og_image
  end
end
