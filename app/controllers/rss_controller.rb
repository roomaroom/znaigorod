class RssController < ApplicationController
  def index
    respond_to do |format|
      format.rss {
        @afishas = AfishaPresenter.new({}).decorated_collection
        @discounts = DiscountsPresenter.new(:per_page => 15).decorated_collection
        @reviews = ReviewsPresenter.new(params).decorated_collection

        render :layout => false
      }
    end
  end
end
