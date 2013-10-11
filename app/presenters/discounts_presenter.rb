# encoding: utf-8

class DiscountsPresenter
  def collection
    Discount.scoped.page(1)
    #searcher.results
  end

  private

  def searcher
    @searcher ||= HasSearcher.searcher(:discounts, searcher_params).tap { |s|
      # s.send "order_by_#{order_by_filter.order_by}"
      s.paginate(page: page, per_page: per_page)
    }
  end
end
