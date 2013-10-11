class DiscountsController < ApplicationController
  inherit_resources

  actions :index, :show

  def index
    index! {
      @presenter = DiscountsPresenter.new

      render partial: 'discounts/discount_posters', layout: false and return if request.xhr?
    }
  end
end
