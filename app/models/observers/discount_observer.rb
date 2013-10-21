class DiscountObserver < ActiveRecord::Observer
  def after_save(discount)
    discount.delay.reindex_organization
  end

  def after_destroy(discount)
    discount.delay.reindex_organization
  end
end
