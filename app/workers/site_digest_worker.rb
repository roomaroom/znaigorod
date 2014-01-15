class SiteDigestWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :mailer, :retry => false

  def perform
    period = 1.week
    digest = SiteDigest.new(period).digest
    accounts = Account.with_email_and_site_digest.where('last_visit_at <= ?', Time.zone.now - period) -
               Role.all.map(&:user).map(&:account).uniq +
               ## NOTICE this array is contained ids of the users which have to receive digest
               Account.where(:id => [2743])

    accounts.each do |account|
      SiteDigestMailer.send_digest(account, digest)
    end

    message = "Site digest sended."

    puts message
    Airbrake.notify(:error_class => "Rake Task", :error_message => message)
  end
end
