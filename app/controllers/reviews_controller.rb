class ReviewsController < ApplicationController
  inherit_resources
  actions :index, :show

  def index
    @presenter = ReviewsPresenter.new(params.merge(:with_advertisement => true))
    @reviews = @presenter.decorated_collection

    render :partial => 'reviews/posters', :locals => { :collection => @reviews, :height => '200', :width => '354' }, :layout => false and return if request.xhr?
  end

  def show
    show!{
      @presenter = ReviewsPresenter.new(params.merge(:with_advertisement => true))

      @review = ReviewDecorator.new(@review)

      @images = Kaminari.paginate_array(@review.images).page(params[:page]).per(30)
      render :partial => 'reviews/gallery' and return if request.xhr?

      @review.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
    }
  end
end
