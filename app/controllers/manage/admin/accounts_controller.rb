class Manage::Admin::AccountsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :index, :edit, :update

  protected

  def collection
    search = Account.search do
      keywords params[:q]

      order_by :created_at, :desc

      paginate paginate_options.merge(:per_page => 20)
    end

    @accounts = search.results
  end
end
