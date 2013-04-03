# encoding: utf-8

class CarServiceCentersPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :lat, :lon, :radius,
                :page, :per_page

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :car_service_center, filters: [:categories, :features, :offers]
end
