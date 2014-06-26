class AddOldSlugToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :old_slug, :string

    Review.where('slug IS NOT NULL').find_each do |review|
      old_slug = review.slug.dup

      review.slug = nil
      review.old_slug = old_slug

      review.save
    end
  end
end
