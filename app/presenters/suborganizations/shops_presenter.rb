class ShopsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :lat, :lon, :radius,
                :page, :per_page

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :shop, filters: [:categories, :features, :offers]
end
