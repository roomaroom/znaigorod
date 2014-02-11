class ReviewsController < ApplicationController
  inherit_resources
  actions :index, :show

  def index
    index!{
      @reviews = collection.map { |item| ReviewDecorator.decorate item }
    }
  end
end
