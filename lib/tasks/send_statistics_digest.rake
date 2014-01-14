# encoding: utf-8

require 'airbrake'

desc "Send by email afisha and discout statistics to users"
task :send_statistics_digest => :environment do

  puts "="*10

  puts "Sending of the afisha and discounts statistics digest. Please wait..."

  counter = SendStatisticsDigest.send

  message = "Statistics digest sending finished. Sended #{counter} emails"
  puts message
  Airbrake.notify(:error_class => "Rake Task", :error_message => message)

  puts "="*10

end

