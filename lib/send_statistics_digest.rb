
class SendStatisticsDigest

  class Digest

    def self.collection_for_email(account, period)
      @account = account
      @period = period
      count
      [
        afisha,
        discounts,
      ].compact
    end

    def self.discounts
      Discount.includes(:votes, :account, :members, :comments, :page_visits)
              .where("discounts.account_id" => @account.id)
              .where('discounts.state' => "published")
              .where("discounts.ends_at >= '#{DateTime.now}' or discounts.ends_at is null")
    end

    def self.afisha
      Afisha.actual
            .includes(:invitations, :comments, :visits, :showings)
            .where("afisha.user_id = '#{account.users.first.id}'")
            .where(:state => "published")
    end

  end


  def self.send
    period = 1.day
    accounts = Account.with_email.where('last_visit_at <= ? and account_settings.statistics_digest = true', Time.zone.now - period)
    managers = Role.all.map(&:user).map(&:account).uniq
    counter = 0
    (accounts - managers).each do |account|
      digest = Digest.collection_for_email(account, period)
      StatisticsDigestMailer.send_digest(account, digest)
    end
  end

end
