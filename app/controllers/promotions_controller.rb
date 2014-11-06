class PromotionsController < ApplicationController
  def show
    PromotionWorker.perform_async(params[:url], params[:channel], request.subdomain)
    render :nothing => true
  end
end
