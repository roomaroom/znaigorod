desc "Update trailers from youtube.com: object tag -> http link"
task :update_trailers => :environment do

  bar = ProgressBar.new(Movie.count)
  count = 0
  Movie.all.each do |movie|
    unless movie.trailer_code.blank?
      code = movie.trailer_code.match(/youtube\.com\/v\/(.{11})/)
      if code
        count += 1
        movie.update_attribute(:trailer_code, "http://www.youtube.com/watch?v=#{code[1]}")
      end
    end
    bar.increment!
  end
  puts "Updated: #{count} items"

end
