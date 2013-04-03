# encoding: utf-8

class SalonCentersPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :lat, :lon, :radius,
                :page, :per_page

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :salon_center, filters: [:categories, :features, :offers]
end

