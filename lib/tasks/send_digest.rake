require 'airbrake'
require 'optparse'
require_relative '../../app/workers/personal_digest_worker'
require_relative '../../app/workers/site_digest_worker'
require_relative '../../app/workers/statistics_digest_worker'

namespace :send_digest do

  desc 'Delivers digest to users'

  desc "Send by email personal digest to users"
  task :personal => :environment do
    puts "Sending of personal digest. Please wait..."
    visit_period = 1.day
    accounts = Account.with_email.with_personal_digest.where('last_visit_at <= ?', Time.zone.now - visit_period) - Role.all.map(&:user).map(&:account).uniq
    accounts.each do |account|
      PersonalDigestWorker.perform_async(account.id)
    end
    message = "Personal digest sended."
    puts message
    Airbrake.notify(:error_class => "Rake Task", :error_message => message)
  end

  desc "Send by email site digest to users"
  task :site => :environment do
    puts "Sending of site digest. Please wait..."

    if ENV['accounts'].present?
      args = ENV['accounts'].split(',').map(&:squish)
    end

    SiteDigestWorker.perform_async(args)
  end

  desc "Send by email afisha and discout statistics to users"
  task :statistics => :environment do
    puts "Sending of the afisha and discounts statistics digest. Please wait..."
    accounts = Account.with_email.with_statistics_digest - Role.all.map(&:user).map(&:account).uniq
    accounts.each do |account|
      StatisticsDigestWorker.perform_async(account.id)
    end
    message = "Statistics digest sending finished."
    puts message
    Airbrake.notify(:error_class => "Rake Task", :error_message => message)
  end

end