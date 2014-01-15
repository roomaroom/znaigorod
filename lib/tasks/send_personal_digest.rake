# encoding: utf-8

require 'airbrake'
require 'progress_bar'

desc "Send by email personal digest to users"
task :send_personal_digest => :environment do

  puts "="*10

  puts "Sending of personal digest. Please wait..."

  visit_period = 1.day
  accounts = Account.with_email_and_pesonal_digest.where('last_visit_at <= ?', Time.zone.now - visit_period) - Role.all.map(&:user).map(&:account).uniq

  bar = ProgressBar.new(accounts.count)

  accounts.each do |account|
    PersonalDigestMailer.delay(:queue => 'mailer').send_digest(account)
    sleep 0.5
    bar.increment!
  end

  message = "Personal digest sending finished."
  puts message
  Airbrake.notify(:error_class => "Rake Task", :error_message => message)

end
