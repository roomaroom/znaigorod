class Post < ActiveRecord::Base
end

class RemovePosts < ActiveRecord::Migration
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
    remove_posts
    remove_posts_table
  end

  def down
  end
end
