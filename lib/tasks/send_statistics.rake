# encoding: utf-8

desc "Send by email afisha and discout statistics to users"
task :send_statistics => :environment do
  puts "="*10

  puts "Sending statistics. Please wait..."

  puts "Sending afisha statistics. Please wait..."

  Account.send_afisha_statistics

  puts "Sending discount statistics. Please wait..."

  Account.send_discount_statistics

  puts "="*10

end

