class PersonalDigestMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)
  add_template_helper(EmailDigestHelper)

  def send_digest(account, digest)
    @digest = digest
    @type = "new_notifications"
    mail(:to => account.email, :subject => t("notice_mailer.personal_digest")).deliver!
  end

end
