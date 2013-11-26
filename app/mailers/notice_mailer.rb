class NoticeMailer < ActionMailer::Base
  default :from => Settings['mail']['from']
  layout "notice_layout"

  def personal_invitation invite
    @invite = invite
    @type = "personal_invitation"
    #mail(:to => invite.invited.email, :subject => 'invite hello')
    mail(:to => 'tsaazi@gmail.com', :subject => '', :layout => "layout").deliver!
  end

  def private_message message
    @message = message
    @type = "private_message"
    mail(:to => message.account.email, :subject => 'messagehello').deliver!
  end

  def comment_to_afisha comment
    @comment = comment
    @type = "comment_to_afisha"
    mail(:to => comment.commentable.user.account.email, :subject => 'afisha comment hello')
  end

  def comment_to_discount comment
    @comment = comment
    @type = "comment_to_discount"
    mail(:to => comment.commentable.account.email, :subject => 'discount comment hello')
  end

  def comment_reply comment
    @comment = comment
    @type = "comment_reply"
    mail(:to => comment.parent.user.account.email, :subject => 'comment reply hello')
  end

  def comment_like vote
    @vote = vote
    @type = "comment_like"
    mail(:to => vote.voteable.user.account.email, :subject => 'comment like hello')
  end

  def afisha_statistics afishas, account
    @account = account
    @afishas = afishas
    @type = "afisha_statistics"
    mail(:to => account.email, :subject => 'afisha stat hello')
  end

  def discount_statistics discounts, email
    @discounts = discounts
    @account = account
    @type = "discount_statistics"
    mail(:to => account.email, :subject => 'discount stat hello')
  end

  def send_message
    #mail(:to => 'aisling.nimdis@yandex.ru', :subject => 'yes').deliver!
    #mail(:to => 'aisling.nimdis@gmail.com', :subject => 'yes').deliver!
    mail(:to => 'tsaazi@gmail.com', :subject => 'yes').deliver!
    #mail(:to => 'nimdis@bk.ru', :subject => 'yes').deliver!
  end

end
