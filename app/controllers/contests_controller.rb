class ContestsController < ApplicationController

  def show
    @contest = Contest.published.latest_contest
    raise ActionController::RoutingError.new('Not Found') unless @contest
  end

end
