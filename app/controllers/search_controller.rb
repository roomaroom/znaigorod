class SearchController < ApplicationController
  helper_method :collection, :total

  protected
    def search
      @search ||= Sunspot.search([Affiche, Organization]) {
        keywords(params[:q])
        paginate(paginate_options)

        any_of do
          all_of do
            with(:kind, 'affiche')
            with(:last_showing_time).greater_than(DateTime.now)
          end

          all_of do
            with(:kind, 'organization')
          end

        end
      }
    end

    def collection
      @collection ||= search.results
    end

    def total
      search.total
    end
end
