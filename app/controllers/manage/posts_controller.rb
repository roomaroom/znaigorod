class Manage::PostsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all
end
