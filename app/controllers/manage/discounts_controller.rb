class Manage::DiscountsController < Manage::ApplicationController
  actions :all

  def update
    update! do |success, failure|
      success.html {
        if params[:crop]
          redirect_to poster_manage_discount_path(resource)
        else
          redirect_to manage_discount_path(resource)
        end
      }

      failure.html {
        render :poster and return if params[:crop]

        render :edit
      }
    end
  end

  private

  def collection
    @collection = Discount.page(params[:page] || 1).per(10)
  end
end
