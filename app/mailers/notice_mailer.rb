class NoticeMailer < ActionMailer::Base
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"
  add_template_helper(ImageHelper)

  def personal_invitation(invite)
    @invite = invite
    @type = "personal_invitation"
    return if invite.invited.blank?
    mail(:to => invite.invited.email, :subject => t("notice_mailer.new_invitation"), :layout => "layout")
  end

  def private_message(message)
    @message = message
    @type = "private_message"
    mail(:to => message.account.email, :subject => t("notice_mailer.new_private_message"))
  end

  def comment_to_afisha(comment)
    @comment = comment
    @type = "comment_to_afisha"
    return if comment.commentable.blank?
    mail(:to => comment.commentable.user.account.email, :subject => t("notice_mailer.new_comment_to_afisha"))
  end

  def comment_to_discount(comment)
    @comment = comment
    @type = "comment_to_discount"
    return if comment.commentable.blank?
    mail(:to => comment.commentable.account.email, :subject => t("notice_mailer.new_comment_to_discount"))
  end

  def comment_reply(comment)
    @comment = comment
    @type = "comment_reply"
    return if comment.parent.blank?
    mail(:to => comment.parent.user.account.email, :subject => t("notice_mailer.new_comment_reply"))
  end

  def comment_like(vote)
    @vote = vote
    @type = "comment_like"
    return if vote.voteable.blank?
    mail(:to => vote.voteable.user.account.email, :subject => t("notice_mailer.new_comment_like"))
  end

  #=====================================================================================================

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

  def digest(digest, account)
    @digest = digest
    @account = account
    @type = "digest"
    mail(:to => account.email, :subject => t("notice_mailer.digest")).deliver!
  end

end
