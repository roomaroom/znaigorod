# encoding: utf-8

require 'airbrake'
require 'progress_bar'
require_relative '../../app/workers/personal_digest_worker'

desc "Send by email personal digest to users"
task :send_personal_digest => :environment do

  puts "Sending of personal digest. Please wait..."

  visit_period = 1.day
  accounts = Account.with_email.with_personal_digest.where('last_visit_at <= ?', Time.zone.now - visit_period) - Role.all.map(&:user).map(&:account).uniq

  bar = ProgressBar.new(accounts.count)

  accounts.each do |account|
    PersonalDigestWorker.perform_async(account.id)
    bar.increment!
  end

  message = "Personal digest sended."
  puts message
  Airbrake.notify(:error_class => "Rake Task", :error_message => message)

end
