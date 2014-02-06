class MainPageController < ApplicationController
  def show
    advertisement = Advertisement.new(list: 'main_page_afisha')
    @afisha_list          = AfishaPresenter.new(:per_page => 6, :without_advertisement => true, :has_tickets => true, :order_by => 'creation').decorated_collection
    advertisement.places_at(1).each do |adv|
      @afisha_list[adv.position] = adv
    end
    @afisha_filter   = AfishaPresenter.new(:has_tickets => false)
    @organizations   = OrganizationsCatalogPresenter.new(:per_page => 6, :sms_claimable => true, :only_clients => true)

    @certificates    = DiscountsPresenter.new(:type => 'certificate', :per_page => 3, :order_by => 'random').decorated_collection
    @offered_discount = DiscountsPresenter.new(:type => 'offered_discount', :per_page => 2, :order_by => 'random').decorated_collection
    @discounts       = [@certificates, @offered_discount].flatten.shuffle
    advertisement = Advertisement.new(list: 'main_page_discounts')
    advertisement.places_at(1).each do |adv|
      @discounts[adv.position] = adv
    end

    @discount_filter = DiscountsPresenter.new(params)
    @accounts        = AccountsPresenter.new(:per_page => 6, :acts_as => ['inviter', 'invited'], :with_avatar => true)
    @webcams         = Webcam.our.published.shuffle.take(5)
  end
end
