class RemovePublishedFromContests < ActiveRecord::Migration
  def up
    remove_column :contests, :published
  end

  def down
    add_column :contests, :published, :boolean
  end
end
