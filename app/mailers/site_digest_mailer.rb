class SiteDigestMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)

  def send_digest(account, digest)
    @digest = digest
    @type = "site_digest"
    mail(:to => account.email, :subject => t("notice_mailer.site_digest")).deliver!
  end

end
