class WorksController < ApplicationController
  inherit_resources
  belongs_to :contest

  load_and_authorize_resource :only => [:new, :create]

  actions :new, :create, :show

  def create
    create! { contest_path(@work.contest) }
  end

  protected

  def build_resource
    @work = super.tap { |w| w.account_id = current_user.account_id }
  end
end
