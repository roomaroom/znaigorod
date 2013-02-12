class AddVkLikesToWorks < ActiveRecord::Migration
  def change
    add_column :works, :vk_likes, :integer
  end
end
