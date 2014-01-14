# encoding: utf-8

desc "Send by email personal digest to users"
task :send_personal_digest => :environment do

  puts "="*10

  puts "Sending of personal digest. Please wait..."

  counter = SendPersonalDigest.send

  message = "Personal digest sending finished. Sended #{counter} emails"
  puts message
  Airbrake.notify(:error_class => "Rake Task", :error_message => message)

  puts "="*10

end
