class AddCachedContentForReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :cached_content_for_index, :text
    add_column :reviews, :cached_content_for_show, :text

    Review.all.map { |r| r.save(:validate => false) }
  end
end
