#encoding: utf-8

class OfferMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def mail_new_offer(offer)
    @offer = offer
    mail(:to => Settings['mail']['to_office'], :subject => 'Добавлено новое предложение цены')
  end

  def mail_offer_paid(offer)
    @offer = offer
    mail(:to => Settings['mail']['to_office'], :subject => 'Оплата за предложение цены')
  end
end
