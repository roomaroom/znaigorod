# encoding: utf-8

require 'progress_bar'
require 'social_likes'

desc 'Get social likes for afishas, organizations, reviews and discounts'
task :social_likes => :environment do
  likes = SocialLikes.new

  [Afisha, Organization, Review, Discount, Work].each do |klass|
    collection = case klass
                 when Afisha
                   klass.published.actual.with_showings
                 when Discount
                   klass.published.actual
                 when Review
                   klass.with_period.published
                 when Work
                   klass.where(:context_type => Photogallery)
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
