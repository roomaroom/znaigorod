class Manage::BannersController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:show]

  protected
  def collection
    search_query = params[:search].try(:[], :q)
    page = params[:page] || 1

    @banners = end_of_association_chain.search {
      fulltext search_query
      order_by :updated_at, :desc
      paginate :page => page, :per_page => 10
    }.results
  end
end
