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

      @review.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
    }
  end
end
