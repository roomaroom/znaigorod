desc 'Update ponominalu tickets'
task :update_ponominalu_tickets => :environment do
  PonominaluTicket.available.find_each(&:save)
end
