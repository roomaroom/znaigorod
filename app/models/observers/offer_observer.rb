# encoding: utf-8

class OfferObserver < ActiveRecord::Observer
  def after_create(offer)
    OfferMailer.delay(:queue => 'mailer').mail_new_offer(offer)
  end

  def after_approve(offer, transition)
    create_payment(offer)
    create_notification(offer)
    create_sms(offer)
  end

  def after_cancel(offer, transition)
    create_sms(offer)
  end

  private

  def create_payment(offer)
    payment = offer.build_offer_payment
    payment.amount  = offer.our_stake
    payment.phone   = offer.phone
    payment.details = offer.details
    payment.save!
  end

  def create_notification(offer)
    NotificationMessage.delay(:queue => 'critical').create(
      :account => offer.account,
      :kind => :offer_approved,
      :messageable => offer)
  end

  def create_sms(offer)
    offer.create_sms!(:phone => offer.phone, :message => I18n.t("offer.#{offer.state}", :our_stake => offer.our_stake, :organization_stake => offer.organization_stake))
  end
end
