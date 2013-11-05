class Manage::RedClothController < Manage::ApplicationController
  load_and_authorize_resource

  def show
    render :text => params[:text].try(:as_html)
  end
end
