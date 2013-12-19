class SiteDigestMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)

  def send_digest
    @digest = make_digest(period)
    Account.where("email is not null and last_visit_at <= #{DateTime.now - 1.week}").each do |account|
      mail(:to => account.email, :subject => t("notice_mailer.site_digest")).deliver!
    end
  end

  def make_digest(period)
    {
      events:        SendSiteDigest.actual_events(period),
      discounts:     SendSiteDigest.new_discounts(period),
      dating:        SendSiteDigest.dating(period),
      organizations: SendSiteDigest.new_organizations(period)
    }
  end
end
