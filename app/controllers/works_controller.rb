class WorksController < ApplicationController
  inherit_resources

  actions :new, :create, :show

  belongs_to :contest

  protected

  def build_resource
    super.account = current_user.try(:account)
  end
end
