class AddPosterToPosts < ActiveRecord::Migration
  def up
    disable_callback
    set_poster_image_url
  end

  def down
  end

  def disable_callback
    Post.skip_callback :save, :before, :set_poster
  end

  def set_poster_image_url
    pb = ProgressBar.new(Post.count)

    Post.all.each do |post|
      begin
        url = Posts::ContentParser.new(post.content).poster

        post.poster_image = url
        post.save! :validate => false
      rescue
        puts "Unable to set poster for Post with id = #{post.id}"
      end

      pb.increment!
    end
  end
end
