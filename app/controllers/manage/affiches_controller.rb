class Manage::AffichesController < Manage::ApplicationController
  inherit_resources

  actions :all, :except => :show
end
