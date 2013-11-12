class MainPageController < ApplicationController
  def show
    @afisha          = AfishaPresenter.new(:per_page => 6, :without_advertisement => true, :has_tickets => true)
    @afisha_filter   = AfishaPresenter.new(:has_tickets => false)
    @organizations   = OrganizationsCatalogPresenter.new(:per_page => 6, :sms_claimable => true)
    @discounts       = DiscountsPresenter.new(:per_page => 5, :type => 'certificate')
    @discount_filter = DiscountsPresenter.new(params)
    @accounts        = AccountsPresenter.new(:per_page => 6, :acts_as => ['inviter', 'invited'], :with_avatar => true)
  end
end
