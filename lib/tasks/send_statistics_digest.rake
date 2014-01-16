# encoding: utf-8

require 'airbrake'
require 'progress_bar'
require_relative '../../app/workers/statistics_digest_worker'

desc "Send by email afisha and discout statistics to users"
task :send_statistics_digest => :environment do

  puts "Sending of the afisha and discounts statistics digest. Please wait..."

  accounts = Account.with_email.with_statistics_digest - Role.all.map(&:user).map(&:account).uniq
  bar = ProgressBar.new(accounts.count)

  accounts.each do |account|
    StatisticsDigestWorker.perform_async(account.id)
    bar.increment!
  end

  message = "Statistics digest sending finished."
  puts message
  Airbrake.notify(:error_class => "Rake Task", :error_message => message)

end
