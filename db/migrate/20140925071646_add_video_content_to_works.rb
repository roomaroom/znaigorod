class AddVideoContentToWorks < ActiveRecord::Migration
  def change
    add_column :works, :video_content, :text
  end
end
