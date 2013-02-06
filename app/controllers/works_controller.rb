class WorksController < ApplicationController
  has_scope :page, :default => 1

  def index
    @contest = Contest.first
    @works = @contest.works.ordered.page(params[:page]).per(9)
  end

  def show
    @work = Work.find(params[:id])
  end
end
