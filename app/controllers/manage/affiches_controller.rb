class Manage::AffichesController < Manage::ApplicationController
  actions :index, :new

  has_scope :page, :default => 1

  protected
    def collection
      @search ||= Sunspot.search(Affiche) do
        keywords(params[:q])
        paginate(:page => params[:page], :per_page => 20)
      end

      @search.results
    end
end
