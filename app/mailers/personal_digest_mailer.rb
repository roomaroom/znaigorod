class PersonalDigestMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)

  def send_digest(account, digest)
    @digest = digest
    @type = "new_notifications"
    mail(:to => account.email, :subject => t("notice_mailer.site_digest")).deliver!
    raise 'yes'
  end

end
