class ReviewsController < ApplicationController
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
    # /reviews/:year-:month/:id support
    review = Review.published.find_by_slug(params[:id])

    unless review
      review = Review.published.find_by_old_slug(params[:id])

      redirect_to review_path(review) and return if review

      raise ActiveRecord::RecordNotFound
    end

    @review = ReviewDecorator.new(review)

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
