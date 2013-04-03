class Manage::SalonCentersController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  def index
    @collection = SalonCenter.page(params[:page] || 1).per(10)
  end
end

