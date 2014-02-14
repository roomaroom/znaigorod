class ReviewsController < ApplicationController
  inherit_resources
  actions :index, :show

  def index
    @presenter = ReviewsPresenter.new(params.merge(:with_advertisement => true))
  end

  def show
    show!{
      @review = ReviewDecorator.new(@review)

      @review.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
    }
  end
end
