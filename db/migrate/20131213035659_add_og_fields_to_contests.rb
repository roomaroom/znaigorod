class AddOgFieldsToContests < ActiveRecord::Migration
  def up
    add_column :contests, :og_description, :text
    add_attachment :contests, :og_image
  end

  def down
    remove_column :contests, :og_description
    remove_attachment :contests, :og_image
  end
end
