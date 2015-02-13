class Manage::MainPageReviewsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => :show

  def index
    @main_page_reviews = MainPageReview.ordered

    search = Review.search { fulltext params[:term]; with :state, :published }
    reviews = search.results

    respond_to do |format|
      format.html
      format.json { render :json => reviews.map { |r|  { :label => r.title, :value => r.id } } }
    end
  end

  def sort
    begin
      params[:position].each do |id, position|
        MainPageReview.find(id).update_attribute :position, position
      end
    rescue Exception => e
      render :text => e.message, :status => 500 and return
    end

    render :nothing => true, :status => 200
  end

end
