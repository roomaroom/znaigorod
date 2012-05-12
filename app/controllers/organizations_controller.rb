class OrganizationsController < ApplicationController
  inherit_resources

  actions :index, :show

  layout 'public'

  respond_to :json

  def index
    index! {
      if request.xhr?
        render :action => 'index', :layout => false and return
      end
    }
  end

  protected
    def collection
      @search ||= Organization.search do
        fulltext params[:q]

        all_of do
          Organization::FACETS.each do |facet|
            params_facet_values(facet).each do |value|
              with(facet, value)
            end
          end

          with(:capacity).greater_than(capacity) if capacity?
        end

        Organization::FACETS.each do |facet|
          facet(facet, :zeros => true, :sort => :index)
        end
      end

      @search.results
    end

    def capacity
      params[:capacity].to_i
    end

    def capacity?
      capacity > 0
    end
end
