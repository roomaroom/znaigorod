class Manage::DiscountsController < Manage::ApplicationController
  actions :all

  private

  def collection
    @collection = Discount.page(params[:page] || 1).per(10)
  end
end
