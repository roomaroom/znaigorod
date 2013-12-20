class SiteDigestMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)

  def send_digest
    Account.where("email is not null and last_visit_at <= #{DateTime.now - 1.day}").each do |account|
      @digest = SendPersonalDigest.made_digest(account, period)
      mail(:to => account.email, :subject => t("notice_mailer.site_digest")).deliver!
    end
  end

end
