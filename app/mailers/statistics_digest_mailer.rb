class StatisticsDigestMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)
  add_template_helper(EmailDigestHelper)

  def send_digest(account)
    @type = "statistics_digest"

    @digest = SendStatisticsDigest.collection_for_email(account)

    mail(:to => account.email, :subject => t("notice_mailer.statistics_digest")) unless @digest.flatten.blank?
  end

end
