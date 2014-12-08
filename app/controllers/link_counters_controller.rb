class LinkCountersController < ApplicationController
  def create
    if request.xhr?
      link = LinkCounter.where(params_for_search).first || LinkCounter.create(link_type: params[:link_type], name: params[:name], link: params[:link])
      link.increment! :count
      render nothing: true and return
    end
  end

  def params_for_search
    params[:name].blank? ? "link = '#{params[:link]}'" : "name = '#{params[:name]}'"
  end
end
