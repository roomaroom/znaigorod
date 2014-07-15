class My::RelatedItemsController < ApplicationController
  def afishas
    searcher = HasSearcher.searcher(:afishas, :q => search_param, :state => 'published')
      .paginate(:page => page, :per_page => per_page)

    @related_afishas = searcher.results
    @related_items = relatedItems("afisha")

    render :partial => 'my/related_items/afishas' if request.xhr?
  end

  def organizations
    searcher = HasSearcher.searcher(:organizations, :q => search_param, :state => 'published')
      .order_by_rating
      .paginate(page: page, per_page: per_page)

    @related_items = relatedItems("organization")
    @related_organizations = searcher.results

    render :partial => 'my/related_items/organizations' if request.xhr?
  end

  def reviews
    searcher = HasSearcher.searcher(:reviews, :q => search_param, :state => 'published')
      .order_by_creation
      .paginate(page: page, per_page: per_page)

    @related_items=relatedItems("review")
    @related_reviews = searcher.results

    render :partial => 'my/related_items/reviews' if request.xhr?
  end

  private
  def relatedItems(itemName)
    return [] unless params[:relatedItemsIds]

    params[:relatedItemsIds].inject([]) { |array, item|
      type, id = item.split("_")

      array << id.to_i if itemName == type

      array
    }
  end

  def search_param
    params[:search_param]
  end

  def per_page
    12
  end

  def page
    params[:page]
  end
end
