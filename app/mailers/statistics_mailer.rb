class StatisticsMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)

  def afisha_statistics(afishas, account)
    @account = account
    @afishas = afishas
    @type = "afisha_statistics"
    mail(:to => account.email, :subject => t("notice_mailer.afisha_statistics")).deliver!
  end

  def discount_statistics(discounts, account)
    @discounts = discounts
    @account = account
    @type = "discount_statistics"
    mail(:to => account.email, :subject => t("notice_mailer.discount_statistics")).deliver!
  end

end
