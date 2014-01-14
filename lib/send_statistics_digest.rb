
class SendStatisticsDigest

  class Digest

    def self.collection_for_email(account)
      @account = account
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
            .where("afisha.user_id = ?", @account.users.first.id)
            .where(:state => "published")
    end

  end


  def self.send
    counter = 0

    accounts = Account.with_email
    managers = Role.all.map(&:user).map(&:account).uniq
    # NOTICE this array is contained ids of the users which have to receive digest
    should_receive = Account.where(:id => [2743])

    (accounts - managers + should_receive).each do |account|
      if account.account_settings.statistics_digest?
        digest = Digest.collection_for_email(account)
        unless digest.flatten.blank?
          StatisticsDigestMailer.send_digest(account, digest)
          counter += 1
        end
      end
    end

    counter
  end

end
