class Manage::PlaceItemsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:show]
end
