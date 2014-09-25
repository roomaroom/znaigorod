class Manage::WorksController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show]

  belongs_to :contest, :polymorphic => true, :optional => true
  belongs_to :photogallery, :polymorphic => true, :optional => true

  def create
    create! { [:manage, @work.context] }
  end

  def update
    update! { [:manage, @work.context] }
  end

  private

  def build_resource
    unless params[:type].nil?
      klass = params[:type].constantize
      @work = klass.new(params[:work])
      @work.context = Contest.find(params[:contest_id])
      @work
    else
      @work = Contest.find(params[:contest_id]).works.new
    end
  end
end
