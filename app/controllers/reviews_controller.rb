class ReviewsController < ApplicationController
  inherit_resources
  actions :index, :show

  def index
    index!{
      @reviews = collection.map { |item| ReviewDecorator.decorate item }
    }
  end

  def show
    show!{
      @review = ReviewDecorator.new(@review)
    }
  end
end
