class SiteDigestMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)

  def send_digest
    @digest = SendSiteDigest.made_digest(period)
    Account.where("email is not null and last_visit_at <= #{DateTime.now - 1.week}").each do |account|
      mail(:to => account.email, :subject => t("notice_mailer.new_notifications")).deliver!
    end
  end

end
