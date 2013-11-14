class NoticeMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def personal_invitation invite
    @invite = invite
    #mail(:to => invite.invited.email, :subject => 'invite hello')
  end

  def private_message message
    @message = message
    mail(:to => message.account.email, :subject => 'messagehello')
  end

  def comment_to_afisha comment
    @comment = comment
    mail(:to => comment.commentable.user.account.email, :subject => 'afisha comment hello')
  end

  def comment_reply comment
    @comment = comment
    mail(:to => comment.parent.user.account.email, :subject => 'comment reply hello')
  end

  def comment_like vote
    @vote = vote
    mail(:to => vote.voteable.user.account.email, :subject => 'comment like hello')
  end

  def afisha_statistics afisha
    @afisha = afisha
    mail(:to => afisha.user.account.email, :subject => 'afisha stat hello')
  end

  def discount_statistics discounts, email
    @discounts = discounts
    mail(:to => email, :subject => 'discount stat hello')
  end

end
