class AddPosterToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :poster_image_url, :text
    add_column :reviews, :poster_image_file_name, :string
    add_column :reviews, :poster_image_content_type, :string
    add_column :reviews, :poster_image_file_size, :integer
    add_column :reviews, :poster_image_updated_at, :datetime
  end
end
