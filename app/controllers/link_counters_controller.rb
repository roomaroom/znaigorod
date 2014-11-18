class LinkCountersController < ApplicationController
  def create
    if request.xhr?
      LinkCounter.delay.create(link_type: params[:link_type], name: params[:name], link: params[:link])
      render nothing: true and return
    end
  end
end
