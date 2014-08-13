class ContestsController < ApplicationController

  def index
    @contests = Contest.available
  end

  def show
    @contest = Contest.find(params[:id])
    @works = @contest.works.ordered.page(params[:page]).per(12)
    @reviews = ReviewDecorator.decorate(@contest.reviews)

    render :partial => 'works/contest_list' and return if request.xhr?
  end
end
