class NoticeMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def personal_invitation invite
    @invite = invite
    mail(:to => invite.invited.email, :subject => 'invite hello')
  end

  def private_message message
    @message = message
    mail(:to => message.account.email, :subject => 'invite hello')
  end

  def comment_to_afisha comment
    @comment = comment
    mail(:to => comment.account.email, :subject => 'invite hello')
  end

  def comment_reply
    @comment = comment
    mail(:to => comment.parent.user.account.email, :subject => 'invite hello')
  end

  def comment_like

  end

  def afisha_statistics

  end

  def discount_statistics

  end

end
