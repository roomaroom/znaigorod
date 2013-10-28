# encoding: utf-8

class DiscountObserver < ActiveRecord::Observer
  def after_save(discount)
    return unless discount.published?

    discount.delay(:queue => 'critical').upload_poster_to_vk if (discount.poster_vk_id.nil? || discount.poster_url_changed?) && discount.poster_url?
  end

  def after_to_published(discount, transition)
    MyMailer.delay(:queue => 'mailer').mail_new_published_discount(discount) unless discount.account.is_admin?
  end
end
