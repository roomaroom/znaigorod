class BannersController < ApplicationController
  respond_to :promotion

  def show
    @banner = Banner.find(params[:id])
  end
end
