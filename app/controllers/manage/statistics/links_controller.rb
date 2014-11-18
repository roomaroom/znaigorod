class Manage::Statistics::LinksController < Manage::ApplicationController
  load_and_authorize_resource

  def index
    @links = params[:order].present? ? LinkCounter.with_link_type(params[:order]).group(:link).count : LinkCounter.group(:link).count
  end
end
