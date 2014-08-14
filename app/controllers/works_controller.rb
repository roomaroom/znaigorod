class WorksController < ApplicationController
  inherit_resources
  belongs_to :contest, :polymorphic => true, :optional => true
  belongs_to :photogallery, :polymorphic => true, :optional => true

  load_and_authorize_resource :only => [:new, :create]

  actions :new, :create, :show

  def create
    create! { @work.context }
  end

  def show
    show! {
      @work.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
      @photogalleries = Photogallery.limit(5)
    }
  end

  protected

  def build_resource
    @work = super.tap { |w| w.account_id = current_user.account_id }
  end
end
