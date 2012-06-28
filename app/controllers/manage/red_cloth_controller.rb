class Manage::RedClothController < Manage::ApplicationController
  def show
    html = params[:text] ? RedCloth.new(params[:text]).gilensize.to_html : ''

    render :text => html
  end
end
