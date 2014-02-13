class MigratePostsToReviews < ActiveRecord::Migration
  def up
    raise "\nSKIP FOR A WHILE\n\n"

    pb = ProgressBar.new(Post.count)

    Review.destroy_all

    Post.all.each do |post|
      review = ReviewArticle.new do |r|
        r.content      = post.content
        r.categories   = post.categories
        r.title        = post.title
        r.tag          = post.tag
        r.poster_image = URI.parse(post.poster_image_url) if post.poster_image_url
        r.account      = post.account
      end

      review.save :validate => false

      pb.increment!
    end
  end

  def down
  end
end
