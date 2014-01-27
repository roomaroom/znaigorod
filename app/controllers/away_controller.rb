class AwayController < ActionController::Base
  def go
    redirect_to params[:to]
  end
end
