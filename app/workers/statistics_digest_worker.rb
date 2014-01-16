class StatisticsDigestWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :mailer, :retry => false

  def perform(account_id)
    account = Account.find(account_id)
    digest = Digest::Statistics.new(account).digest

    StatisticsDigestMailer.send_digest(account, digest)
  end
end
