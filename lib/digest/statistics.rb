require 'afisha'
require 'discount'

class Digest::Statistics

  attr_accessor :account, :digest

  def initialize(account)
    @account = account
    @digest = [
      afisha,
      discounts,
    ].compact
  end

  def afisha
    Afisha.actual
    .includes(:invitations, :comments, :visits, :showings)
    .where("afisha.user_id = ?", @account.users.first.id)
    .where(:state => "published")
  end

  def discounts
    Discount.includes(:votes, :account, :members, :comments, :page_visits)
    .where("discounts.account_id" => @account.id)
    .where('discounts.state' => "published")
    .where("discounts.ends_at >= '#{DateTime.now}' or discounts.ends_at is null")
  end

end
