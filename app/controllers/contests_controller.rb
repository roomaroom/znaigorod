class ContestsController < ApplicationController

  def index
    @contests = Contest.ordered_by_starts_on
  end

  def show
    @contest = Contest.find(params[:id])
  end

end
