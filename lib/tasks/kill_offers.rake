desc 'Update state for stale offers'
task :kill_offers => :environment do
  Offer.by_state(:approved).where('updated_at <= ?', Time.zone.now - 2.hours).map(&:die!)
end
