# encoding: utf-8

require 'progress_bar'

desc "Пересчет рейтинга организиции"
task :recalculate_rating => :environment do
  bar = ProgressBar.new(Organization.count)
  Organization.find_each do |organization|
    organization.recalculate_rating
    bar.increment!
  end
end
