class Manage::Statistics::LinksController < Manage::ApplicationController
  authorize_resource

  def index
    @links = params[:order_by].present? ? LinkCounter.with_link_type(params[:order_by]) : LinkCounter.all
  end

  def edit
    @link = LinkCounter.find(params[:id])
  end

  def update
    @link = LinkCounter.find(params[:id])
    @link.human_name = params[:link_counter][:human_name]
    if @link.save
      redirect_to manage_statistics_links_path
    else
      render 'edit'
    end
  end
end
