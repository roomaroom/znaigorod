class StatisticsDigestMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)
  add_template_helper(EmailDigestHelper)

  def send_digest(account, digest)
    @digest = digest
    @type = "statistics_digest"
    mail(:to => account.email, :subject => t("notice_mailer.statistics_digest")).deliver!
  end

end
