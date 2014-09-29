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
      context_klass = params[:context_type].constantize
      @work.context = context_klass.find(params["#{params[:context_type].underscore}_id"])
    else
      context_klass = params[:context_type].constantize
      @work = context_klass.find(params["#{params[:context_type].underscore}_id"]).works.new
    end
  end
end
