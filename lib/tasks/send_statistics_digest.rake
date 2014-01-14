# encoding: utf-8

desc "Send by email afisha and discout statistics to users"
task :send_statistics => :environment do
  # NOTICE comments are an example of the system audit

  #message = "Afisha statistic sending finished. Sended #{count} emails"
  #puts message
  #Airbrake.notify(:error_class => "Rake Task", :error_message => message)

  puts "="*10

  puts "Sending of the afisha and discounts statistics digest. Please wait..."

  SendStatisticsDigest.send

  puts "="*10

end

