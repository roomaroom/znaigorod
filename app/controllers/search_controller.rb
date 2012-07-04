class SearchController < ApplicationController
  helper_method :collection, :total

  protected
    def search
      @search = HasSearcher.searcher(:total, params)
    end

    def collection
      @collection ||= search.results
    end

    def total
      search.total
    end
end
