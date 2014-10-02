class SaunasController < ApplicationController
  def index
    @presenter = SaunaHallsPresenter.new(params)
    @discount_collection = SaunasDiscountsPresenter.new({}).collection
    render partial: 'sauna_posters', layout: false and return if request.xhr?
  end
end
