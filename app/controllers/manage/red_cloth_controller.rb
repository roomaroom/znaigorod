class Manage::RedClothController < Manage::ApplicationController
  def show
    html = params[:text] ? RedCloth.new(params[:text]).to_html : ''

    render :text => html
  end
end
