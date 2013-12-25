# encoding: utf-8

class SendSiteDigest

  class Digest

    def self.count
      @count ||= 4
    end

    def self.collection_for_email(period)
      @period = period
      count
      [
        actual_events,
        new_organizations,
        new_discounts,
        dating,
      ].compact
    end

    def self.actual_events
      afisha = Afisha.actual.where("afisha.created_at > ?", Time.zone.now - @period).sort_by{|a| -a[:total_rating]}
      if afisha.count < @count
        sorted_afisha = Afisha.actual.sort_by{|a| -a[:total_rating]}
        (0..(@count - afisha.count - 1)).each do |i|
          afisha.push sorted_afisha[i]
        end
      end
      afisha.first(@count)
    end

    def self.new_discounts
      @certificates = DiscountsPresenter.new(:type => 'certificate', :order_by => 'rating').collection
      @offered_discount = DiscountsPresenter.new(:type => 'offered_discount', :order_by => 'rating').collection
      discounts = [@certificates, @offered_discount].flatten
                                                    .compact
                                                    .sort_by{ |e| e.created_at }
                                                    .select{|x| x.created_at > (Time.zone.now - @period)}
      if discounts.select{|x| x.created_at > (Time.zone.now - @period)}.count < @count
        sorted_discounts = [@certificates, @offered_discount].flatten
                                                                       .compact
                                                                       .sort_by{ |e| -e[:total_rating] }

        (0..(@count - discounts.count - 1)).each do |i|
          discounts.push sorted_discounts[i]
        end
      else
        discounts = discounts.select{|x| x.created_at > (Time.zone.now - @period)}
      end
      discounts.first(@count)
    end

    def self.dating
      output = []
      %w[male female].each do |gender|
        accounts = []
        prepared_accounts = Account.where("gender = ? and created_at > ?", gender, Time.zone.now - @period).order("rating DESC")

        prepared_accounts.each do |a|
          if a.rating.present? && a.with_avatar? && a.invitations.with_categories.any?
            accounts.push a
          end
        end

        (0..(@count - accounts.count - 1)).each do |i|
          accounts.push prepared_accounts[i]
        end

        output.push accounts.any? ? accounts.first(@count) : []
      end
      output
    end

    def self.new_organizations
      organizations = OrganizationsCatalogPresenter.new(:per_page => 1000, :sms_claimable => true, :only_clients => true)
                                                   .collection
                                                   .sort_by { |e| e[:created_at] }
                                                   .select{|x| x.created_at > (Time.zone.now - @period)}
      prepared_organizations = OrganizationsCatalogPresenter.new(:per_page => 1000, :sms_claimable => true, :only_clients => true)
                                                            .collection.sort_by {|e| e[:total_rating]}

      (0..(@count - organizations.count - 1)).each do |i|
        organizations.push prepared_organizations[i]
      end

      organizations.reverse.first(@count)
    end

  end

  def self.send
    period = 1.week
    digest = Digest.collection_for_email(period)

    Account.with_email.where('last_visit_at <= ?', Time.zone.now - period).where("gender = 'male'").limit(1).each do |account|
      SiteDigestMailer.send_digest(account, digest)
    end
  end

end
