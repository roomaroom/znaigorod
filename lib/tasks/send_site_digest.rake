# encoding: utf-8

require 'airbrake'

desc "Send by email site digest to users"
task :send_site_digest => :environment do

  puts "="*10

  puts "Sending of site digest. Please wait..."

  counter = SendSiteDigest.send

  message = "Site digest sending finished. Sended #{counter} emails"
  puts message
  Airbrake.notify(:error_class => "Rake Task", :error_message => message)

  puts "="*10

end

