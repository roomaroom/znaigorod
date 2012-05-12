class Manage::OrganizationsController < Manage::ApplicationController
  inherit_resources
  has_searcher

  protected
    def build_resource
      super

      (1..7).each do |day|
        resource.schedules.build(:day => day)
      end unless resource.schedules.any?

      resource
    end

    def collection
      @search ||= Organization.search do
        fulltext params[:organization_search].try(:[], :keywords)
        facet(:category)
        facet(:feature)
        facet(:cuisine)
        facet(:payment)
        paginate(:page => params[:page], :per_page => 20)
      end
      @search.results
    end
end
