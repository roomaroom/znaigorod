# encoding: utf-8

class OfferObserver < ActiveRecord::Observer
  def after_create(offer)
    OfferMailer.delay(:queue => 'mailer').mail_new_offer(offer)
  end
end
