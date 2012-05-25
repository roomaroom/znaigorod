class AffichesController < InheritedResourcesController
  actions :index, :show

  has_scope :page, :default => 1
  has_scope :with_showings, :default => true, :type => :boolean

  layout 'public'

  def index
    render :partial => 'item', :collection => collection, :layout => false and return if request.xhr?

    index!
  end

  protected
    def collection
      get_collection_ivar || set_collection_ivar(search_and_paginate_collection)
    end

    def search_and_paginate_collection
      params[:utf8] ? search_results : results
    end

    def results
      end_of_association_chain.page(page).per(per_page)
    end

    def search_results
      showing_ids = ShowingSearch.new(params[:search]).result_ids
      affiche_ids = Showing.unscoped.where(:id => showing_ids).group(:affiche_id).pluck(:affiche_id)

      Affiche.where(:id => affiche_ids).page(page).per(per_page)
    end

    def page
      params[:page].blank? ? 1 : params[:page].to_i
    end

    def per_page
      params[:per_page].to_i.zero? ? 20 : params[:per_page].to_i
    end

    def paginate_options
      {
        :page       => page,
        :per_page   => per_page
      }
    end
end
