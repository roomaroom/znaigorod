class AddPosterImageToLegacyPosters < ActiveRecord::Migration
  def first_img(content)
    img_match_data = content.scan(/<img.*?\/>/).first
    return nil unless img_match_data

    src_match_data = img_match_data.match(/src="(.*?)"/)
    return nil unless src_match_data

    src_match_data[1]
  end

  def stub_poster(post)
    file = File.open(Rails.root.join('app/assets/images/public/post_poster_stub.jpg'))

    post.poster_image = file
    post.save! :validate => false
  end

  def change
    pb = ProgressBar.new(Post.count)

    Post.find_each do |post|
      if url = first_img(post.content)
        tempfile = Tempfile.open('poster')
        tempfile.binmode

        begin
          tempfile << open(url, :read_timeout => 3).read

          post.poster_image = tempfile
          post.save! :validate => false
        rescue
          puts "Unable to load #{url}"

          stub_poster(post)
        end
      else
        stub_poster(post)
      end

      pb.increment!
    end
  end
end
