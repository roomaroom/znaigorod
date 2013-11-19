class MainPageController < ApplicationController
  def show
    @afisha          = AfishaPresenter.new(:per_page => 6, :without_advertisement => true, :has_tickets => true, :order_by => 'random')
    @afisha_filter   = AfishaPresenter.new(:has_tickets => false)
    @organizations   = OrganizationsCatalogPresenter.new(:per_page => 6, :sms_claimable => true, :only_clients => true)

    @berloga         = DiscountsPresenter.new(:organization_id => 183, :type => 'coupon', :per_page => 2, :order_by => 'random').decorated_collection
    @certificates    = DiscountsPresenter.new(:type => 'certificate', :per_page => 3, :order_by => 'random').decorated_collection
    @discounts       = [@berloga, @certificates].flatten.shuffle

    @discount_filter = DiscountsPresenter.new(params)
    @accounts        = AccountsPresenter.new(:per_page => 6, :acts_as => ['inviter', 'invited'], :with_avatar => true)
    @webcams         = Webcam.our.published.shuffle.take(5)
  end
end
