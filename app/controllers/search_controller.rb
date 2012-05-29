class SearchController < ApplicationController
  helper_method :collection

  private
    def collection
      @collection ||= Sunspot.search([Affiche, Organization]) {
        keywords(params[:q])

        any_of do
          all_of do
            with(:kind, 'affiche')
            with(:last_showing_time).greater_than(DateTime.now)
          end

          all_of do
            with(:kind, 'organization')
          end
        end
      }.results
    end
end
