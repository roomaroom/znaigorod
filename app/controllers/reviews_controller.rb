class ReviewsController < ApplicationController
  inherit_resources
  actions :index, :show

  def index
    respond_to do |format|
      format.html {
        @presenter = ReviewsPresenter.new(params.merge(:with_advertisement => true))
        @reviews = @presenter.decorated_collection

        render :partial => 'reviews/posters', :locals => { :collection => @reviews, :height => '200', :width => '354' }, :layout => false and return if request.xhr?
      }

      format.rss do
        @presenter = ReviewsPresenter.new(params)

        render :layout => false
      end

      format.promotion {
        presenter = ReviewsPresenter.new(params.merge(:per_page => 5))

        render :partial => 'promotions/reviews', :locals => { :presenter => presenter }
      }
    end
  end

  def show
    @review = ReviewDecorator.new Review.published.find(params[:id])
    respond_to do |format|
      format.html {
        @presenter = ReviewsPresenter.new(params.merge(:category => @review.categories.map(&:value).first, :type => @review.useful_type))

        @images = Kaminari.paginate_array(@review.images).page(params[:page]).per(30)
        render :partial => 'reviews/gallery', :layout => false and return if request.xhr?

        @review.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
      }
      format.promotion {
        render :partial => 'promotions/review', :locals => { :decorated_review => @review }
      }
    end
  end
end
