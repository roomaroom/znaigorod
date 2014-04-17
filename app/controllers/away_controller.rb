class AwayController < ActionController::Base
  def go
    redirect_to params[:to] || root_path
  end
end
