# encoding: utf-8

require 'airbrake'
require 'progress_bar'

desc "Send by email afisha and discout statistics to users"
task :send_statistics_digest => :environment do

  puts "="*10

  puts "Sending of the afisha and discounts statistics digest. Please wait..."

  accounts = Account.with_email_and_stat_digest - Role.all.map(&:user).map(&:account).uniq

  bar = ProgressBar.new(accounts.count)
  accounts.each do |account|
    StatisticsDigestMailer.delay(:queue => 'mailer').send_digest(account)
    sleep 0.5
    bar.increment!
  end

  message = "Statistics digest sending finished."
  puts message
  Airbrake.notify(:error_class => "Rake Task", :error_message => message)

end
