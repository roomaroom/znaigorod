class LinkCountersController < ApplicationController
  def create
    if request.xhr?
      link = LinkCounter.where(test).first || LinkCounter.create(link_type: params[:link_type], name: params[:name], link: params[:link])
      link.increment! :count
      render nothing: true and return
    end
  end

  def test
    params[:name].empty? ? "link = '#{params[:link]}'" : "name = '#{params[:name]}'"
  end
end
