class Manage::OffersController < Manage::ApplicationController
  load_and_authorize_resource

  actions :index, :destroy
end
