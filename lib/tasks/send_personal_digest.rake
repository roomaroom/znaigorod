# encoding: utf-8

desc "Send by email personal digest to users"
task :send_personal_digest => :environment do
  puts "="*10

  puts "Sending of personal digest. Please wait..."

  SendPersonalDigest.send

  puts "="*10
end
