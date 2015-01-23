desc 'Refresh copies'
task :refresh_copies => :environment do
  Copy.reserved.where('updated_at <= ?', Time.zone.now - 1.hour).map(&:release!)

  Ticket.for_stale.each do |ticket|
    ticket.emails.each do |email|
      CopyPaymentMailer.delay(:queue => 'mailer').report(email, ticket)
    end if ticket.copies.sold.any?
    ticket.stale!
  end

  Discount.with_emails.where(:type => %w[Counpon Certificate]).where(:stale => false).each do |discount|
    discount.emails.each do |email|
      CopyPaymentMailer.delay(:queue => 'mailer').report(email, discount)
    end

    discount.update_attribute :stale, true
  end
end
