class Manage::OrganizationsController < Manage::ApplicationController
  protected
    def collection
      @search ||= Sunspot.search([Eating, Funny]) do
        fulltext params[:organization_search].try(:[], :keywords)
        facet(:organization_categories)
        facet(:feature)
        facet(:cuisine)
        facet(:payment)
        paginate(:page => params[:page], :per_page => 20)
      end

      @search.results
    end
end
