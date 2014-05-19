class Manage::MainPageReviewsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:new, :create, :show, :destroy]

  def index
    @main_page_reviews = MainPageReview.all
  end
end
