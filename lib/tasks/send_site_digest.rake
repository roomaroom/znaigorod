# encoding: utf-8

desc "Send by email site digest to users"
task :send_site_digest => :environment do
  puts "="*10

  puts "Sending of site digest. Please wait..."

  SendSiteDigest.send

  puts "="*10

end

