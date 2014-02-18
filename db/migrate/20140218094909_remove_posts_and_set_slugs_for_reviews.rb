class RemovePostsAndSetSlugsForReviews < ActiveRecord::Migration
  def set_slugs
    pb = ProgressBar.new(Review.count)

    Review.published.find_each do |review|
      review.send :set_slug

      review.save :validate => false

      pb.increment!
    end
  end

  def remove_posts
    pb = ProgressBar.new(Post.count)

    Post.find_each do |post|
      post.destroy

      pb.increment!
    end
  end

  def remove_posts_table
    drop_table :posts
  end

  def up
    set_slugs
    remove_posts
    remove_posts_table
  end

  def down
  end
end
