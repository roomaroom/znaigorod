
class SendStatisticsDigest

  attr_accessor :account, :digest

  def self.collection_for_email(account)
    @account = account
    @objects = [
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
