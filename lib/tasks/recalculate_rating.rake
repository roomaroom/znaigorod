# encoding: utf-8

require 'progress_bar'

def recalculate_rating(options={})
  clazz = options.delete(:class)
  puts "recalculate rating for #{clazz}"
  bar = ProgressBar.new(clazz.count)
  clazz.find_each do |object|
    object.recalculate_rating
    bar.increment!
  end
end

desc "Пересчет рейтинга организиции"
task :recalculate_rating => :environment do
  recalculate_rating :class => Organization
  recalculate_rating :class => Affiche
end

