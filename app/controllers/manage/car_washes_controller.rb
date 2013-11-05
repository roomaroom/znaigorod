class Manage::CarWashesController < Manage::ApplicationController
  load_and_authorize_resource

  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  def index
    @collection = CarWash.page(params[:page] || 1).per(10)
  end
end
