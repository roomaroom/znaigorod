class Manage::OrganizationsController < Manage::ApplicationController
  actions :index, :new

  has_scope :page, :default => 1

  respond_to :json

  protected
    def collection
      @search ||= Sunspot.search([Eating, Funny]) do
        keywords(params[:q])
        paginate(:page => params[:page], :per_page => 20)
      end

      @search.results
    end
end
