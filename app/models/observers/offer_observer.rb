# encoding: utf-8

class OfferObserver < ActiveRecord::Observer
  def after_create(offer)
    OfferMailer.delay(:queue => 'mailer').mail_new_offer(offer)
  end

  def after_approve(offer, transition)
    if offer.account.present?
      NotificationMessage.delay(:queue => 'critical').create(
        :account => offer.account,
        :kind => :offer_approved,
        :messageable => offer)
    end
  end
end
