class WorksController < ApplicationController
  inherit_resources
  belongs_to :contest, :photogallery, :polymorphic => true

  load_and_authorize_resource :only => [:new, :create]

  actions :new, :create, :show

  def create
    create! { @work.context }
  end

  protected

  def build_resource
    @work = super.tap { |w| w.account_id = current_user.account_id }
  end
end
