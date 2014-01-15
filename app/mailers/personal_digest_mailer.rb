class PersonalDigestMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)
  add_template_helper(EmailDigestHelper)

  def send_digest(account)
    visit_period = 1.day
    @type = "new_notifications"

    @digest = SendPersonalDigest.collection_for_email(account, visit_period)
    @account = account
    mail(:to => account.email, :subject => t("notice_mailer.personal_digest")) unless @digest.flatten.blank?

  end

end
