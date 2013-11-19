desc 'Update state for stale offers'
task :kill_offers => :environment do
  Offer.approved.where('updated_at <= ?', Time.zone.now - 3.hours).map(&:die!)
end
