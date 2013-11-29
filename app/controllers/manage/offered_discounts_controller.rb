class Manage::OfferedDiscountsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show, :destroy]

  def create
    create! do |success, failure|
      success.html { redirect_to manage_discount_path(resource) and return }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to manage_discount_path(resource) and return }
    end
  end
end
