class CooperationController < ApplicationController
  helper_method :view_type

  def benefit
  end

  def statistics
  end

  def extra_catalogs
  end

  def services
    @service_payment = ServicePayment.new
  end

  def our_customers
    @presenter = OrganizationsCatalogPresenter.new(params.merge(:only_clients => true).merge(:per_page => 21))

    render partial: 'organizations/organizations_posters', layout: false and return if request.xhr?
  end

  def view_type
    'tile'
  end

  def ticket_sales
  end
end
