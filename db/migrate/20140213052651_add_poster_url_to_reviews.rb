class AddPosterUrlToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :poster_url, :text
  end
end
