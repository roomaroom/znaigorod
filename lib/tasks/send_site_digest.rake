# encoding: utf-8

require 'airbrake'
require_relative '../../app/workers/site_digest_worker'

desc "Send by email site digest to users"
task :send_site_digest => :environment do

  puts "Sending of site digest. Please wait..."

  SiteDigestWorker.perform_async

end

