class SiteDigestWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :mailer, :retry => false

  def perform(args = nil)
    period = 1.week
    digest = Digest::Site.new(period).digest
    accounts = []
    if args.present?
      args.flatten.each do |account_id|
        begin
          account = Account.find(account_id)
        rescue => e
        end
        accounts << account if account.present? && account.email.present?
      end
    else
      accounts = Account.with_email.with_site_digest.where('last_visit_at <= ?', Time.zone.now - period) -
                 Role.all.map(&:user).map(&:account).uniq +
                 ## NOTICE this array is contained ids of the users which have to receive digest
                 Account.where(:id => [2743])
    end

    accounts.each do |account|
      SiteDigestMailer.send_digest(account, digest)
    end

    message = "Site digest sended."

    puts message
    Airbrake.notify(:error_class => "Rake Task", :error_message => message)
  end
end
