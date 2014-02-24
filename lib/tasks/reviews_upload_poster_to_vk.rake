desc 'Reviews upload poster to vk'
task :reviews_upload_poster_to_vk => :environment do
  pb = ProgressBar.new(Review.count)

  Review.published.each do |review|
    review.upload_poster_to_vk if review.has_poster?
    pb.increment!
  end
end
