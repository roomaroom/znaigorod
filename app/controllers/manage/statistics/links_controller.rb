class Manage::Statistics::LinksController < Manage::ApplicationController
  authorize_resource
  helper_method :page

  def index
    @links = params[:order_by].present? ? LinkCounter.with_link_type(params[:order_by]).ordered.page(page).per(20) : LinkCounter.ordered.page(page).per(20)
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


  private

  def page
    params[:page] || 1
  end
end
