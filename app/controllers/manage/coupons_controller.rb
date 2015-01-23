class Manage::CouponsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show, :destroy]

  def edit
    edit! {
      render text: params[:id] and return if request.xhr?
    }
  end

  def create
    create! { |success, failure|
      success.html { redirect_to manage_discount_path(resource) }
    }
  end

  def update
    update! { manage_discount_path resource }
  end
end
