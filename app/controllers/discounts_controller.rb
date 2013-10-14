class DiscountsController < ApplicationController
  inherit_resources

  actions :index, :show

  def index
    index! {
      @presenter = DiscountsPresenter.new(params)

      render partial: 'discounts/discount_posters', layout: false and return if request.xhr?
    }
  end

  def show
    show! {
      @presenter = DiscountsPresenter.new(params)
      @discount = DiscountDecorator.new Discount.find(params[:id])
    }
  end
end
