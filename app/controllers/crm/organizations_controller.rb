class Crm::OrganizationsController < Crm::ApplicationController
  load_and_authorize_resource

  actions :index, :show, :edit, :update

  has_scope :page, default: 1

  def index
    @organizations = HasSearcher.searcher(:manage_organization, params[:search]).
      paginate(page: params[:page] || 1, per_page: 10).results
  end

  def update
    update! { render partial: params[:field] and return }
  end
end
