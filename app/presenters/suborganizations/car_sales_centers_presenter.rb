# encoding: utf-8

class CarSalesCentersPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :lat, :lon, :radius,
                :page, :per_page

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :car_sales_center, filters: [:categories, :features, :offers]
end
