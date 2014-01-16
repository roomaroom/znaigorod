require File.expand_path('../directories.rb', __FILE__)

dir = Directories.new

if RUBY_PLATFORM =~ /freebsd/
  set :job_template, "/usr/local/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
else
  set :job_template, "/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
end

every :thursday, :at => '8:00 am' do
  rake 'send_digest:site'
end

every :day, :at => '6:00 am' do
  rake 'send_digest:personal'
end

every :day, :at => '6:30 am' do
  rake 'send_digest:statistics'
end

every :day, :at => '7:15 am' do
  rake 'sync:fakel'
end

every :day, :at => '7:20 am' do
  rake 'sync:kinomax'
end

every :day, :at => '7:25 am' do
  rake 'sync:kinomir'
end

every 6.hours do
  rake 'sitemap:refresh refresh_sitemaps'
end

every :day, :at => '5am' do
  rake 'refresh_sitemaps'
  rake 'account:get_friends'
  rake 'invitations:destroy_irrelevant'
end

every 2.hours do
  rake 'afisha:event_users'
  rake 'social_likes'
  rake 'actualize_discounts'
end

every 3.hours do
  rake 'update_rating:all'
  rake 'balance_notify'
end

every 6.hours do
  rake 'sitemap:refresh refresh_sitemaps'
end

every 5.minutes do
  rake 'refresh_copies'
  rake 'kill_offers'
end
