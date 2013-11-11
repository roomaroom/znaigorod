class MainPageController < ApplicationController
  def show
    @afisha        = AfishaPresenter.new(:per_page => 6, :without_advertisement => true, :has_tickets => true)
    @organizations = OrganizationsCatalogPresenter.new(:per_page => 6, :sms_claimable => true)
    @discounts     = DiscountsPresenter.new(:per_page => 5, :type => 'certificate')
    @accounts      = AccountsPresenter.new(:per_page => 6, :acts_as => 'inviter', :with_avatar => true)
  end
end
