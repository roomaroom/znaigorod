class SearchController < ApplicationController
  helper_method :collection, :total

  protected
    def search
      @search = HasSearcher.searcher(:total, params).boost_by(:first_showing_time_dt)
    end

    def collection
      @collection ||= search.results
    end

    def total
      search.total
    end
end
