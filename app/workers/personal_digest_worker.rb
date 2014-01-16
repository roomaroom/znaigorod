class PersonalDigestWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :mailer, :retry => false

  def perform(account_id)
    visit_period = 1.day
    account = Account.find(account_id)
    digest = PersonalDigest.new(account, visit_period).digest

    PersonalDigestMailer.send_digest(account, digest)
  end
end
