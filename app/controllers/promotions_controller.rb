class PromotionsController < ApplicationController
  def show
    PromotionWorker.perform_async(params[:url], params[:channel])
    render :nothing => true
  end
end