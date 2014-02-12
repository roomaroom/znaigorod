class AddVideoUrlToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :video_url, :text
  end
end
