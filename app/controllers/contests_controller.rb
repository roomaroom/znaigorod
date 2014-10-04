class ContestsController < ApplicationController

  helper_method :page, :per_page, :current_count, :total_count

  def index
    @contests = Contest.available
  end

  def show
    @contest = Contest.find(params[:id])
    @works = @contest.works.ordered.page(page).per(per_page)
    @reviews = ReviewDecorator.decorate(@contest.reviews)

    render :partial => 'works/contest_list', :locals => { :current_count => current_count, :width => @contest.is_a?(ContestVideo) ? 350 : 278 , :height => @contest.is_a?(ContestVideo) ? 200 : 278 } and return if request.xhr?
  end

  def current_count
    total_count - (page.to_i * per_page)
  end

  def page
    params[:page] || 1
  end

  def per_page
    12
  end

  def total_count
    @contest.works.count
  end
end
