class Manage::BannersController < Manage::ApplicationController
  load_and_authorize_resource
  actions :all, :except => [:show]
end
