class WorksController < ApplicationController
  inherit_resources

  authorize_resource :only => :new

  actions :new, :create, :show

  belongs_to :contest

  def create
    create! { contest_path(@work.contest) }
  end

  protected

  def build_resource
    @work = super.tap { |w| w.account_id = current_user.account_id }
  end
end
