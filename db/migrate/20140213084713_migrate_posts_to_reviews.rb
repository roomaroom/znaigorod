class MigratePostsToReviews < ActiveRecord::Migration
  def handle_associations(post, review)
    associations_data = {
      :comments => :commentable,
      :gallery_images => :attachable,
      :messages => :messageable,
      :page_visits => :page_visitable,
      :votes => :voteable
    }

    associations_data.each do |association, method|
      post.send(association).each do |item|
        item.send "#{method}=", review

        item.save :validate => false
      end
    end
  end

  def set_type(review)
    if review.gallery_images.count > 5
      review.type = 'ReviewPhoto'
      review.save :validate => false

      return
    end

    content_parser = Reviews::Content::Parser.new(review.content)

    if content_parser.videos.one?
      review.content = nil
      review.video_url = content_parser.videos.first.url
      review.type = 'ReviewVideo'

      review.save :validate => false
    end
  end

  def up
    pb = ProgressBar.new(Post.count)

    Post.all.each do |post|
      review = ReviewArticle.new do |r|
        r.account      = post.account
        r.categories   = post.categories
        r.content      = post.content
        r.poster_image = URI.parse(post.poster_image_url) if post.poster_image_url
        r.state        = post.state
        r.tag          = post.tag
        r.title        = post.title

        r.created_at   = post.created_at
        r.updated_at   = post.updated_at
      end

      review.save :validate => false

      handle_associations(post, review)
      set_type(review)

      pb.increment!
    end
  end

  def down
  end
end
