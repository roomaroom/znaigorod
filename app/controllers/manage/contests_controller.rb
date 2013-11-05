class Manage::ContestsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all

  def index
    @collection = Contest.page(params[:page] || 1).per(10)
  end
end
