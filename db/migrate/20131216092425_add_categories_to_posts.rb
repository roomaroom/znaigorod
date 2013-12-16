class AddCategoriesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :categories, :text
  end
end
