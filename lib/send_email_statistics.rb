# encoding: utf-8

class SendEmailStatistics

  def self.send_discount_statistics
    accounts = Account.where("email is not null")
    managers = Role.all.map(&:user).map(&:account).uniq
    counter = 0
    (accounts - managers).each do |account|
      begin
        if account.account_settings.discounts_statistics
          if send_discounts(account)
            counter = counter + 1
          end
        end
      rescue
        next
      end
    end
    counter
  end

  def self.send_discounts(account)
    discounts = Discount.includes(:votes, :account, :members, :comments, :page_visits)
      .where("discounts.account_id" => account.id)
      .where('discounts.state' => "published")
      .where("discounts.ends_at >= '#{DateTime.now}' or discounts.ends_at is null")

    if discounts.any? && account.email.present?
      StatisticsMailer.discount_statistics(discounts, account)
      return true
    else
      return false
    end
  end

  def self.send_afisha_statistics
    accounts = Account.where("email is not null")
    managers = Role.all.map(&:user).map(&:account).uniq
    counter = 0
    (accounts - managers).each do |account|
      begin
        if account.account_settings.afishas_statistics
          answer = send_afishas(account)
          if answer
            counter = counter + 1
          end
        end
      rescue
        next
      end
    end
    counter
  end

  def self.send_afishas(account)
    afishas =  Afisha
      .actual
      .includes(:invitations, :comments, :visits, :showings)
      .where("afisha.user_id = '#{account.users.first.id}'")
      .where(:state => "published")

    if afishas.any? && account.email.present?
      StatisticsMailer.afisha_statistics(afishas, account)
      return true
    else
      return false
    end
  end

end
