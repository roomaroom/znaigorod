class My::RelatedItemsController < ApplicationController

  def afishas
    searcher = HasSearcher.searcher(:showings).tap { |s|
      s.paginate(page: page, per_page: per_page)
      s.groups
      s.send("order_by_creation")
      s.actual
    }

    afisha_ids = searcher.group(:afisha_id_str).groups.map(&:value)
    @related_afishas = Afisha.where(id: afisha_ids)

    render :partial => 'my/related_items/afishas' if request.xhr?
  end

  def organizations
    searcher = HasSearcher.searcher(:organizations).tap { |s|
      s.send("order_by_rating")
      s.paginate(page: page, per_page: per_page)
    }

    @related_organizations = searcher.results
  end

  def reviews
    searcher = HasSearcher.searcher(:reviews).tap { |s|
      s.send("order_by_creation")
      s.paginate(page: page, per_page: per_page)
    }
    @related_reviews = searcher.results
  end

  private
  def per_page
    6
  end

  def page
    params[:page]
  end
end
