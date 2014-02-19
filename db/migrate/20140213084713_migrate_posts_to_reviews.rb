class Post < ActiveRecord::Base
  extend Enumerize

  has_many :comments,       :as => :commentable,    :dependent => :destroy
  has_many :gallery_images, :as => :attachable,     :dependent => :destroy
  has_many :messages,       :as => :messageable,    :dependent => :destroy
  has_many :page_visits,    :as => :page_visitable, :dependent => :destroy
  has_many :votes,          :as => :voteable,       :dependent => :destroy

  has_one :feed,   :dependent => :destroy, :as => :feedable

  has_attached_file :poster_image, :storage => :elvfs, :elvfs_url => Settings['storage.url'], :default_url => 'public/post_poster_stub.jpg'
  alias_attribute :file_url, :poster_image_url

  serialize :categories, Array
  enumerize :categories,
    in: [:auto, :sport, :entertainment, :humor, :family, :culture, :accidents, :animals, :informative, :creation, :cafe, :other],
    multiple: true,
    predicates: true
end

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
        r.account_id           = post.account_id
        r.afisha_id            = post.afisha_id
        r.allow_external_links = post.allow_external_links
        r.categories           = post.categories.any? ? post.categories : [:other]
        r.content              = post.content
        r.organization_id      = post.organization_id
        r.poster_image         = URI.parse(post.poster_image_url) if post.poster_image_url
        r.slug                 = post.slug
        r.state                = post.state
        r.tag                  = post.tag
        r.title                = post.title

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
