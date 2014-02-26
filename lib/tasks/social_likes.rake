# encoding: utf-8

require 'progress_bar'
require 'social_likes'

desc 'Get social likes for afishas, organizations, reviews and discounts'
task :social_likes => :environment do
  likes = SocialLikes.new

  [Afisha, Organization, Review, Discount].each do |klass|
    collection = case klass
                 when Afisha
                   klass.published.with_showings
                 when Discount, Review
                   klass.published
                 else
                   klass.all
                 end

    puts "Getting likes for #{klass}"
    bar = ProgressBar.new(collection.count)
    collection.each do |item|
      likes.damn_likes(item)
      bar.increment!
    end
  end
end
