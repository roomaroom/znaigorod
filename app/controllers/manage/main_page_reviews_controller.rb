class Manage::MainPageReviewsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:new, :create, :show, :destroy]

  def index
    @main_page_reviews = MainPageReview.ordered

    search = Review.search { fulltext params[:term] }
    reviews = search.results

    respond_to do |format|
      format.html
      format.json { render :json => reviews.map { |r|  { :label => r.title, :value => r.id } } }
    end
  end
end
