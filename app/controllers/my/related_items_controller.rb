class My::RelatedItemsController < ApplicationController

  def afishas
    searcher = HasSearcher.searcher(:showings, :q => search_param).tap { |s|
      s.paginate(page: page, per_page: per_page)
      s.groups
      s.send("order_by_creation")
      s.actual
    }

    afisha_ids = searcher.group(:afisha_id_str).groups.map(&:value)
    @related_afishas = Afisha.where(id: afisha_ids)
    @related_items = relatedItems("afisha")

    @a = AfishaPresenter.new(@related_afishas)
    render :partial => 'my/related_items/afishas' if request.xhr?
  end

  def organizations
    searcher = HasSearcher.searcher(:organizations, :q => search_param).tap { |s|
      s.send("order_by_rating")
      s.paginate(page: page, per_page: per_page)
    }

    @related_items = relatedItems("organization")
    @related_organizations = searcher.results

    render :partial => 'my/related_items/organizations' if request.xhr?
  end

  def reviews
    searcher = HasSearcher.searcher(:reviews, :q => search_param).tap { |s|
      s.send("order_by_creation")
      s.paginate(page: page, per_page: per_page)
    }

    @related_items=relatedItems("review")
    @related_reviews = searcher.results

    render :partial => 'my/related_items/reviews' if request.xhr?
  end

  private
  def relatedItems(itemName)
    arr = Array.new
    params[:relatedItemsIds].each do |item|
      type, id = item.split("_")
      arr << id.to_i if eql_str(itemName, type)
    end unless params[:relatedItemsIds].nil?
    arr
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

  def eql_str(str1,str2)
    condition = str1 <=> str2
    return true if condition == 0
    false
  end
end
