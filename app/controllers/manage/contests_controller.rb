class Manage::ContestsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all

  def index
    @collection = Contest.page(params[:page] || 1).per(10)
  end

  private

  def build_resource
    unless params[:contest][:contest_type].nil?
      klass = params[:contest][:contest_type].classify.constantize
      @contest = klass.new(params[:contest])
    else
      @contest = Contest.new(params[:contest])
    end
  end
end
