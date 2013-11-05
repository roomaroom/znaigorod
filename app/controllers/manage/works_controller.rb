class Manage::WorksController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show]

  belongs_to :contest

  def create
    create! { manage_contest_path(@contest) }
  end

  def update
    update! { manage_contest_path(@contest) }
  end
end
