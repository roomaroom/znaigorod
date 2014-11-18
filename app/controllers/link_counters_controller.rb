class LinkCountersController < ApplicationController
  def create
    if request.xhr?
      link = LinkCounter.where(name: params[:name]).first || LinkCounter.delay.create(link_type: params[:link_type], name: params[:name], link: params[:link])
      link.increment! :count
      render nothing: true and return
    end
  end
end
