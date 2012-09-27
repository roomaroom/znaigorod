# encoding: utf-8

desc "Update trailers from youtube.com: object tag -> http link"
task :update_trailers => :environment do

  bar = ProgressBar.new(Movie.count)
  Movie.all.each do |movie|
    unless movie.trailer_code.blank?
      code = movie.trailer_code.match(/youtube\.com\/v\/(.{11})/)
      movie.update_attribute(:trailer_code, "http://www.youtube.com/watch?v=#{code[1]}") if code
    end
    bar.increment!
  end

end
