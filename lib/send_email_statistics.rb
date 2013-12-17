# encoding: utf-8

class SendEmailStatistics

  def self.send_discount_statistics
    accounts = Account.where("email is not null")
    managers = Role.all.map(&:user).map(&:account).uniq
    (accounts - managers).each do |account|
      if account.account_settings.discounts_statistics
        send_discounts account
      end
    end
  end

  def self.send_discounts account
    discounts = Discount.includes(:votes, :account, :members, :comments, :page_visits)
      .where("discounts.account_id" => account.id)
      .where('discounts.state' => "published")
      .where("discounts.ends_at >= '#{Time.now}' or discounts.ends_at is null")

    if discounts.any?
        NoticeMailer.discount_statistics(discounts, account) unless account.email.blank?
    end
  end

  def self.send_afisha_statistics
    accounts = Account.where("email is not null")
    managers = Role.all.map(&:user).map(&:account).uniq
    (accounts - managers).each do |account|
      begin
        if account.account_settings.afishas_statistics
          send_afishas account
        end
      rescue
        next
      end
    end
  end

  def self.send_afishas account
    afishas =  Afisha
      .actual
      .includes(:invitations, :comments, :visits, :showings)
      .where("afisha.user_id = '#{account.users.first.id}'")
      .where(:state => "published")

    if afishas.any?
      NoticeMailer.afisha_statistics(afishas, account) unless account.email.blank?
    end
  end

  def self.send_digests
    Account.where("last_visit_at < '#{DateTime.now - 1.week}' and email is not null").each do |account|
      digest = account.notification_messages.where(:state => "unread")
      NoticeMailer.digest(digest, account) unless account.email.blank?
    end
  end

end
