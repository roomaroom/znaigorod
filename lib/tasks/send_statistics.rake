# encoding: utf-8

desc "Send by email afisha and discout statistics to users"
task :send_statistics => :environment do
  # TODO uncomment everything!
  puts "="*10

  puts "Sending statistics. Please wait..."

  puts "Sending afisha statistic. Please wait..."

  count = SendEmailStatistics.send_afisha_statistics

  message = "Afisha statistic sending finished. Sended #{count} emails"
  puts message
  #Airbrake.notify(:error_class => "Rake Task", :error_message => message)

  puts "Sending discount statistic. Please wait..."

  count = SendEmailStatistics.send_discount_statistics

  message = "Discounts statistic sending finished. Sended #{count} emails"
  puts message
  #Airbrake.notify(:error_class => "Rake Task", :error_message => message)

  puts "="*10

end

