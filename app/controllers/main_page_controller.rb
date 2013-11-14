class MainPageController < ApplicationController
  def show
    @afisha          = AfishaPresenter.new(:per_page => 6, :without_advertisement => true, :has_tickets => true, :order_by => 'random')
    @afisha_filter   = AfishaPresenter.new(:has_tickets => false)
    @organizations   = OrganizationsCatalogPresenter.new(:per_page => 6, :sms_claimable => true, :only_clients => true)
    @discounts       = DiscountsPresenter.new(:per_page => 5, :type => 'certificate', :order_by => 'random')
    @discount_filter = DiscountsPresenter.new(params)
    @accounts        = AccountsPresenter.new(:per_page => 6, :acts_as => ['inviter', 'invited'], :with_avatar => true)
    @webcams         = Webcam.our.published.shuffle.take(5)
  end
end
