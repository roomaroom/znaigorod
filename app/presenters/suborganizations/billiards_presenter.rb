class BilliardsPresenter < EntertainmentsPresenter
  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :entertainment, filters: []

end
