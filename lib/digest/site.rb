require 'afisha_presenter'
require 'discounts_presenter'
require 'accounts_presenter'
require 'organizations_catalog_presenter'

class Digest::Site

  attr_accessor :digest

  def count
    @count ||= 4
  end

  def initialize(period)
    @period = period
    @digest = [
      actual_events,
      new_organizations,
      new_discounts,
      dating,
    ].compact
  end

  def actual_events
    afisha = Afisha.where('afisha.created_at > ? and afisha.state = ?', Time.zone.now - 1.week, 'published').on_weekend.order("afisha.total_rating desc").sort_by{ |e| -e.total_rating }.first(4)
    prepared_afisha = Afisha.where('afisha.updated_at > ?', Time.zone.now - 1.week).order("afisha.total_rating desc").sort_by{ |e| -e.total_rating }
    if afisha.count < count
      (0..(count - afisha.count - 1)).each do |i|
        afisha << prepared_afisha[i]
      end
    end

    afisha
  end

  def new_discounts
    @certificates = DiscountsPresenter.new(:type => 'certificate', :order_by => 'rating').collection
    @offered_discount = DiscountsPresenter.new(:type => 'offered_discount', :order_by => 'rating').collection
    discounts = [@certificates, @offered_discount].flatten
                                                  .compact
                                                  .sort_by{ |e| e.created_at }
                                                  .select{|x| x.created_at > (Time.zone.now - @period)}
    if discounts.select{|x| x.created_at > (Time.zone.now - @period)}.count < count
      sorted_discounts = [@certificates, @offered_discount].flatten
                                                                     .compact
                                                                     .sort_by{ |e| -e[:total_rating] }

      (0..(count - discounts.count - 1)).each do |i|
        discounts.push sorted_discounts[i]
      end
    else
      discounts = discounts.select{|x| x.created_at > (Time.zone.now - @period)}
    end
    discounts.first(count)
  end

  def dating
    [].tap do |array|
      ['male', 'female', 'undefined'].each do |gender|
        array << AccountsPresenter.new(:per_page => count, :acts_as => ['inviter', 'invited'], :with_avatar => true, :gender => gender).collection
      end
    end
  end

  def new_organizations
    organizations = OrganizationsCatalogPresenter.new(:per_page => 1000, :sms_claimable => true, :only_clients => true)
                                                 .collection
                                                 .sort_by { |e| e[:created_at] }
                                                 .select{|x| x.created_at > (Time.zone.now - @period)}
    prepared_organizations = OrganizationsCatalogPresenter.new(:per_page => 1000, :sms_claimable => true, :only_clients => true)
                                                          .collection.sort_by {|e| e[:total_rating]}

    (0..(count - organizations.count - 1)).each do |i|
      organizations.push prepared_organizations[i]
    end

    organizations.reverse.first(count)
  end

end
