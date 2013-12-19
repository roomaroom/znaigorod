class SendSiteDigest

  @count = 4

  def self.actual_events(period)
    afisha = Afisha.actual.where("afisha.created_at > '#{DateTime.now - period}'").sort_by{|a| -a[:total_rating]}
    puts afisha.count
    puts @count.inspect
    if afisha.count < @count
      sorted_afisha = Afisha.actual.sort_by{|a| -a[:total_rating]}
      (0..(@count - afisha.count - 1)).each do |i|
        afisha.push sorted_afisha[i]
      end
    end
    afisha.first(@count)
  end

  def self.new_discounts(period)
    @certificates = DiscountsPresenter.new(:type => 'certificate', :order_by => 'rating').collection
    @offered_discount = DiscountsPresenter.new(:type => 'offered_discount', :order_by => 'rating').collection
    discounts = [@certificates, @offered_discount].flatten
                                                  .compact
                                                  .sort_by{ |e| e.created_at }
                                                  .select{|x| x.created_at > (DateTime.now - period)}
    if discounts.select{|x| x.created_at > (DateTime.now - period)}.count < @count
      sorted_discounts = [@certificates, @offered_discount].flatten
                                                                     .compact
                                                                     .sort_by{ |e| -e[:total_rating] }

      (0..(@count - discounts.count - 1)).each do |i|
        discounts.push sorted_discounts[i]
      end
    else
      discounts = discounts.select{|x| x.created_at > (DateTime.now - period)}
    end
    discounts.first(@count)
  end

  def self.dating(gender, period)
    if %w[female male].include?(gender)
      accounts = []
      prepared_accounts = Account.where("gender = '#{gender}' and created_at > '#{DateTime.now - period}'").order("rating DESC")
      prepared_accounts
      prepared_accounts.each do |a|
        if a.rating.present? && a.with_avatar? && a.invitations.with_categories.any?
          accounts.push a
        end
      end

      (0..(@count - accounts.count - 1)).each do |i|
        accounts.push prepared_accounts[i]
      end

      accounts.any? ? accounts.first(@count) : nil
    else
      nil
    end
  end

  def self.new_organizations(period)
    organizations = OrganizationsCatalogPresenter.new(:per_page => 1000, :sms_claimable => true, :only_clients => true)
                                                 .collection
                                                 .sort_by { |e| e[:created_at] }
                                                 .select{|x| x.created_at > (DateTime.now - 1.week)}
    prepared_organizations = OrganizationsCatalogPresenter.new(:per_page => 1000, :sms_claimable => true, :only_clients => true)
                                                          .collection.sort_by {|e| e[:total_rating]}

    (0..(@count - organizations.count - 1)).each do |i|
      organizations.push prepared_organizations[i]
    end

    organizations.reverse.first(@count)
  end

end
