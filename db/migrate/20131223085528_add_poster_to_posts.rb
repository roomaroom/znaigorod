class AddPosterToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :poster_id, :integer

    set_poster_for_posts
  end

  def down
    remove_column :posts, :poster_id
  end

  def first_img(content)
    img_match_data = content.scan(/<img.*?\/>/).first
    return nil unless img_match_data

    src_match_data = img_match_data.match(/src="(.*?)"/)
    return nil unless src_match_data

    src_match_data[1]
  end

  def update_poster(post, gallery_image)
    post.update_column :poster_id, gallery_image.id
  end

  def set_poster_for_posts
    pb = ProgressBar.new(Post.count)

    Post.all.each do |post|
      content_parser = Posts::ContentParser.new(post.content)

      if content_parser.gallery_images.any?
        update_poster post, content_parser.gallery_images.first
      else
        if url = first_img(post.content)
          begin
            tempfile = Tempfile.open('poster')
            tempfile.binmode
            tempfile << open(url, :read_timeout => 3).read

            update_poster post, GalleryImage.create!(:file => tempfile)
          rescue
            update_poster post, content_parser.stub_poster
          end
        else
          update_poster post, content_parser.stub_poster
        end
      end

      pb.increment!
    end
  end
end
