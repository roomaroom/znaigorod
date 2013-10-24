# encoding: utf-8

class DiscountObserver < ActiveRecord::Observer
  def after_save(discount)
    return unless discount.published?

    discount.delay(:queue => 'critical').upload_poster_to_vk if (discount.poster_vk_id.nil? || discount.poster_url_changed?) && discount.poster_url?
  end
end
